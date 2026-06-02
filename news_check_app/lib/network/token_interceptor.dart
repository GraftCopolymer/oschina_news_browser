import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:news_check_app/pages/login_page.dart';
import 'package:news_check_app/utils/store_keys.dart';
import 'package:news_check_app/utils/store_utils.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 从 SecureStorage 读取 token 并自动注入 Authorization 头
    final token = await StoreUtils.secure.read(key: StoreKeys.TOKEN);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // 跳转到登录页面
      Get.to(() => LoginPage());
    }
    super.onError(err, handler);
  }
}