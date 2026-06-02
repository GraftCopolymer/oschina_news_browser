import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/utils/store_utils.dart';

enum ReadingBgMode { normal, sepia, dark }

class ReadingSettingsController extends GetxController {
  static const double defaultFontSize = 16;
  static const double defaultLineSpacing = 1.75;
  static const double minFontSize = 14;
  static const double maxFontSize = 24;
  static const double minLineSpacing = 1.2;
  static const double maxLineSpacing = 2.5;

  final fontSize = defaultFontSize.obs;
  final lineSpacing = defaultLineSpacing.obs;
  final readingBg = ReadingBgMode.normal.obs;

  Color get bgColor {
    switch (readingBg.value) {
      case ReadingBgMode.normal: return Colors.white;
      case ReadingBgMode.sepia:  return const Color(0xFFF5E6C8);
      case ReadingBgMode.dark:   return const Color(0xFF1E1E1E);
    }
  }

  Color get textColor {
    switch (readingBg.value) {
      case ReadingBgMode.normal: return const Color(0xFF1E293B);
      case ReadingBgMode.sepia:  return const Color(0xFF3E2E1A);
      case ReadingBgMode.dark:   return const Color(0xFFE0E0E0);
    }
  }

  Color get metaColor => textColor.withAlpha(150);

  String hexColor(Color c) {
    return '#${c.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  String get injectCssVariablesJs => '''
    (function() {
      var root = document.documentElement;
      root.style.setProperty('--font-size', '${fontSize.value}px');
      root.style.setProperty('--line-height', '${lineSpacing.value}');
      root.style.setProperty('--bg-color', '${hexColor(bgColor)}');
      root.style.setProperty('--text-color', '${hexColor(textColor)}');
      root.style.setProperty('--meta-color', '${hexColor(metaColor)}');
    })();
  ''';

  @override
  void onInit() {
    super.onInit();
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = StoreUtils.pref;
    fontSize.value = prefs.getDouble('reading_font_size') ?? defaultFontSize;
    lineSpacing.value = prefs.getDouble('reading_line_spacing') ?? defaultLineSpacing;
    final bgIdx = prefs.getInt('reading_bg_mode') ?? 0;
    readingBg.value = ReadingBgMode.values[bgIdx.clamp(0, ReadingBgMode.values.length - 1)];
  }

  Future<void> saveToPrefs() async {
    final prefs = StoreUtils.pref;
    await prefs.setDouble('reading_font_size', fontSize.value);
    await prefs.setDouble('reading_line_spacing', lineSpacing.value);
    await prefs.setInt('reading_bg_mode', readingBg.index);
  }

  void resetToDefaults() {
    fontSize.value = defaultFontSize;
    lineSpacing.value = defaultLineSpacing;
    readingBg.value = ReadingBgMode.normal;
    saveToPrefs();
  }
}