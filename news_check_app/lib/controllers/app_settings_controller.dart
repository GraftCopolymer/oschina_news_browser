import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/mixins/future_load_mixin.dart';
import 'package:news_check_app/utils/store_keys.dart';
import 'package:news_check_app/utils/store_utils.dart';

class AppSettingsController extends GetxController with FutureLoadMixin {
  final themeMode = MyThemeMode.sys.obs;

  /// 从本地加载设置信息
  Future<void> _loadSettings() async {
    themeMode.value = MyThemeMode.fromValue(StoreUtils.pref.getInt(StoreKeys.THEME_MODE) ?? 0);
  }

  Future<void> saveSettings() async {
    await StoreUtils.pref.setInt(StoreKeys.THEME_MODE, themeMode.value.value);
  }

  @override
  void onInit() {
    super.onInit();
    startLoad();
    _loadSettings().then((_) {
      endLoad();
    });
  }
}

enum MyThemeMode {
  sys(0),
  light(1),
  dark(2);

  final int value;
  const MyThemeMode(this.value);

  ThemeMode toFlutterThemeMode() {
    switch (this) {
      case sys: return ThemeMode.system;
      case light: return ThemeMode.light;
      case dark: return ThemeMode.dark;
    }
  }

  static MyThemeMode fromValue(int val) => 
      values.firstWhere((e) => e.value == val, orElse: () => sys);
}