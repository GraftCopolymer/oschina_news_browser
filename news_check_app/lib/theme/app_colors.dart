import 'package:flutter/material.dart';

/// 青蓝主色调
class AppColors {
  AppColors._();

  // ── 主色 ──
  static const Color primary = Color(0xFF0D9488);      // Teal-600
  static const Color primaryDark = Color(0xFF0F766E);   // Teal-700
  static const Color primaryAccent = Color(0xFF14B8A6); // Teal-500
  static const Color primaryLight = Color(0xFFCCFBF1);  // Teal-100

  // ── 辅助色 ──
  static const Color accentOrange = Color(0xFFF59E0B);

  // ── 卡片背景渐变 ──
  static const List<Color> gradientTeal = [Color(0xFF14B8A6), Color(0xFF0D9488)];
  static const List<Color> gradientPurple = [Color(0xFFA855F7), Color(0xFF7C3AED)];
  static const List<Color> gradientAmber = [Color(0xFFFBBF24), Color(0xFFF59E0B)];
  static const List<Color> gradientGray = [Color(0xFFE2E8F0), Color(0xFFCBD5E1)];

  // ── 深色模式卡片渐变 ──
  static const List<Color> gradientTealDark = [Color(0xFF0F766E), Color(0xFF0D9488)];
  static const List<Color> gradientPurpleDark = [Color(0xFF6B21A8), Color(0xFF7C3AED)];
  static const List<Color> gradientAmberDark = [Color(0xFFB45309), Color(0xFFD97706)];
  static const List<Color> gradientGrayDark = [Color(0xFF334155), Color(0xFF475569)];

  /// 根据 type 返回亮色卡片渐变
  static List<Color> cardGradientForType(int type) {
    const gradients = [
      gradientTeal,    // type=0 链接新闻
      gradientPurple,  // type=1 软件推荐
      gradientAmber,   // type=2 讨论区
      gradientTeal,    // type=3 博客
      gradientGray,    // type=4 普通新闻
      gradientPurple,  // type=5 (预留)
      gradientAmber,   // type=6 (预留)
      gradientTeal,    // type=7 翻译文章
    ];
    return gradients[type.clamp(0, gradients.length - 1)];
  }

  /// 根据 type 返回暗色卡片渐变
  static List<Color> cardGradientDarkForType(int type) {
    const gradients = [
      gradientTealDark,
      gradientPurpleDark,
      gradientAmberDark,
      gradientTealDark,
      gradientGrayDark,
      gradientPurpleDark,
      gradientAmberDark,
      gradientTealDark,
    ];
    return gradients[type.clamp(0, gradients.length - 1)];
  }

  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textDark = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
}