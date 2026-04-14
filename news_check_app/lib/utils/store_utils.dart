import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

class StoreUtils {
  static SharedPreferences? _pref;
  static FlutterSecureStorage? _secureStore;
  static SharedPreferences get pref {
    if (_pref == null) {
      throw Exception("使用 StoreUtils 前请先调用 StoreUtils.init() 方法进行初始化");
    }
    return _pref!;
  }

  static FlutterSecureStorage get secure {
    if (_secureStore == null) {
      throw Exception("使用 StoreUtils 前请先调用 StoreUtils.init() 方法进行初始化");
    }
    return _secureStore!;
  }

  static Future<void> init() async {
    _pref ??= await SharedPreferences.getInstance();
    _secureStore ??= FlutterSecureStorage();
  }
}