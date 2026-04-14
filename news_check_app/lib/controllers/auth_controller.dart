import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:news_check_app/main.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/utils/store_keys.dart';
import 'package:news_check_app/utils/store_utils.dart';

enum UrlFetchStatus { loading, failed, success }
enum LoginAppStatus { loading, failed, success }

class AuthController extends GetxController {
  // 登录状态
  final isLoggedIn = false.obs;
  // 用户 token
  final token = "".obs;
  // 是否正在登录
  final isLogging = false.obs;
  // 用户信息
  final userInfo = Rx(UserInfo(avatar: "", userId: 0, email: "", username: ""));

  // 认证链接相关
  final authUrl = "".obs;
  final urlFetchStatus = UrlFetchStatus.loading.obs;
  String urlFetchErrorMsg = "";

  // 登录 APP 相关
  final loginAppStatus = LoginAppStatus.loading.obs;
  String loginAppErrorMsg = "";

  Completer? _loadingCompleter;
  Future? get loadingFuture => _loadingCompleter?.future;

  @override
  void onInit() {
    super.onInit();
    _loadingCompleter = Completer();
    loadLoginInfo().then((_) {
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    });
  }

  /// 初始化登录信息
  Future<void> loadLoginInfo() async {
    final token = await StoreUtils.secure.read(key: StoreKeys.TOKEN);
    if (token != null && token.isNotEmpty) {
      this.token.value = token;
    }
    if (this.token.value.isNotEmpty) {
      // 加载用户信息
      final userJson = StoreUtils.pref.getString(StoreKeys.USER_INFO);
      if (userJson != null) {
        UserInfo userInfo_ = UserInfo.fromJson(jsonDecode(userJson));
        userInfo.value = userInfo_;
        isLoggedIn.value = true;
      }
    } else {
      isLoggedIn.value = false;
    }
    isLogging.value = false;
  }

  Future<void> fetchAuthUrl() async {
    // 检查是否已经获取过 URL 了
    if (urlFetchStatus.value == UrlFetchStatus.success) {
      return;
    }
    urlFetchStatus.value = UrlFetchStatus.loading;
    try {
      final resp = await api.authOschinaAuthorizeUrlGet();
      if (resp.statusCode == 200) {
        authUrl.value = resp.data!.data!.asMap['auth_url'];
        urlFetchStatus.value = UrlFetchStatus.success;
      } else {
        authUrl.value = "";
        urlFetchStatus.value = UrlFetchStatus.failed;
        urlFetchErrorMsg = "网络错误 ${resp.statusCode}";
      }
    } on DioException catch(e) {
      authUrl.value = "";
      urlFetchStatus.value = UrlFetchStatus.failed;
      urlFetchErrorMsg = "网络错误";
    }
  }

  Future<void> loginApp(String userCode) async {
    loginAppStatus.value = LoginAppStatus.loading;
    try {
      final resp = await api.authOschinaCallbackGet(code: userCode);
      final data = resp.data;
      if (resp.statusCode != 200 || data == null) {
        loginAppStatus.value = LoginAppStatus.failed;
        loginAppErrorMsg = "请求出错";
        return;
      }
      debugPrint("ApiResponse: $data");

      // 提取 Token 信息
      final tokenInfo = data.data!.asMap['data'];
      debugPrint("请求信息: $tokenInfo");
      final accessToken = tokenInfo['accessToken'] as String;
      final UserInfo userInfo_ = UserInfo.fromJson(tokenInfo['userInfo']);

      // 更新状态
      isLoggedIn.value = true;
      isLogging.value = false;
      loginAppStatus.value = LoginAppStatus.success;
      loginAppErrorMsg = "";
      token.value = accessToken;
      userInfo.value = userInfo_;

      // 持久化用户 Token 和用户信息
      await StoreUtils.secure.write(key: StoreKeys.TOKEN, value: accessToken);
      await StoreUtils.pref.setString(StoreKeys.USER_INFO, jsonEncode(userInfo.toJson()));
    } catch (e) {
      debugPrint("APP登录出错: $e");
      loginAppStatus.value = LoginAppStatus.failed;
      loginAppErrorMsg = "登录出错: 未知错误";
    }
  }

  /// 退出登录, 将同时清除本地的所有用户信息
  Future<void> logout() async {
    await StoreUtils.secure.delete(key: StoreKeys.TOKEN);
    await StoreUtils.pref.remove(StoreKeys.USER_INFO);
    // 修改状态
    isLoggedIn.value = false;
    token.value = "";
    isLogging.value = false;
    userInfo.value = UserInfo(userId: 0, username: "", avatar: "", email: "");

    authUrl.value = "";
    urlFetchStatus.value = UrlFetchStatus.loading;

    loginAppStatus.value = LoginAppStatus.loading;
  }
}