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

  // ── 基于标题哈希的渐变 ──

  /// djb2 哈希，保证相同输入始终输出相同值
  static int _hashString(String s) {
    int hash = 5381;
    for (int i = 0; i < s.length; i++) {
      hash = ((hash << 5) + hash) + s.codeUnitAt(i);
    }
    return hash;
  }

  /// 根据标题字符串 + 主题模式生成卡片渐变
  ///
  /// 算法：对标题做 djb2 哈希 → 取模 360 作为 HSL 色相 →
  /// 在固定范围内微调饱和度和明度 → 生成一组渐变用色。
  /// 这样每篇文章的卡片颜色都不同，但同一篇文章总是同一个颜色。
  static List<Color> gradientFromTitle(String title, {required bool isDark}) {
    if (title.isEmpty) {
      return isDark ? gradientTealDark : gradientTeal;
    }
    final hash = _hashString(title);
    final hue = (hash.abs() % 360).toDouble();

    if (isDark) {
      // 深色模式：低饱和、低明度
      final satVariation = (hash.abs() ~/ 360) % 12;
      final saturation = 0.28 + (satVariation / 100.0); // 0.28-0.39
      final lgtVariation = (hash.abs() ~/ 720) % 10;
      final lightness = 0.22 + (lgtVariation / 100.0);  // 0.22-0.31

      final base = HSLColor.fromAHSL(1.0, hue, saturation, lightness);
      final lighter = base.withLightness((lightness + 0.05).clamp(0.0, 1.0));
      final darker = base.withLightness((lightness - 0.05).clamp(0.0, 1.0));
      return [lighter.toColor(), darker.toColor()];
    } else {
      // 亮色模式：中等饱和、中等明度
      final satVariation = (hash.abs() ~/ 360) % 20;
      final saturation = 0.45 + (satVariation / 100.0); // 0.45-0.64
      final lgtVariation = (hash.abs() ~/ 720) % 15;
      final lightness = 0.40 + (lgtVariation / 100.0);  // 0.40-0.54

      final base = HSLColor.fromAHSL(1.0, hue, saturation, lightness);
      final lighter = base.withLightness((lightness + 0.07).clamp(0.0, 1.0));
      final darker = base.withLightness((lightness - 0.07).clamp(0.0, 1.0));
      return [lighter.toColor(), darker.toColor()];
    }
  }

  // ── 基于 type 的固定渐变（保留旧方法，可继续用于收藏页等） ──

  /// 根据 type 返回亮色卡片渐变
  ///
  /// type 取值说明:
  /// - 数字字符串: "0"(链接新闻) "1"(软件推荐) "2"(讨论区) "3"(博客) "4"(普通新闻) "7"(翻译文章)
  /// - 搜索类型字符串: "news"(新闻) "blog"(博客) "project"(开源软件) "post"(帖子/问答)
  static List<Color> cardGradientForType(String type) {
    switch (type) {
      case '0':
      case '3':
      case '7':
      case 'news':
        return gradientTeal;
      case '1':
      case 'project':
        return gradientPurple;
      case '2':
      case 'post':
        return gradientAmber;
      case '4':
      case 'blog':
        return gradientGray;
      default:
        return gradientTeal;
    }
  }

  /// 根据 type 返回暗色卡片渐变
  static List<Color> cardGradientDarkForType(String type) {
    switch (type) {
      case '0':
      case '3':
      case '7':
      case 'news':
        return gradientTealDark;
      case '1':
      case 'project':
        return gradientPurpleDark;
      case '2':
      case 'post':
        return gradientAmberDark;
      case '4':
      case 'blog':
        return gradientGrayDark;
      default:
        return gradientTealDark;
    }
  }

  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textDark = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
}