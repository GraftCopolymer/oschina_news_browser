import 'package:flutter/material.dart';
import 'package:news_check_app/models/models.dart';
import 'package:news_check_app/theme/app_colors.dart';

/// 新闻类型映射为中文标签
String _newsTypeLabel(int type) {
  switch (type) {
    case 0: return '链接';
    case 1: return '软件';
    case 2: return '讨论';
    case 3: return '博客';
    case 4: return '新闻';
    case 7: return '翻译';
    default: return '其他';
  }
}

class StaggeredNewsCard extends StatelessWidget {
  const StaggeredNewsCard({
    super.key,
    required this.news,
    this.onTap,
    this.height,
  });

  final NewsSimple news;
  final void Function(NewsSimple news)? onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.cardGradientDarkForType(news.type)
        : AppColors.cardGradientForType(news.type);

    // 根据渐变亮度决定文字颜色 — 浅色背景用深色文字
    final textColor = colors.first.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
    final textColorSecondary = colors.first.computeLuminance() > 0.5
        ? Colors.black54
        : Colors.white70;
    final textColorTertiary = colors.first.computeLuminance() > 0.5
        ? Colors.black45
        : Colors.white60;

    return GestureDetector(
      onTap: () => onTap?.call(news),
      child: Container(
        height: height ?? 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.last.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 类型标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: textColor.withAlpha(30),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _newsTypeLabel(news.type),
                style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 标题
            Expanded(
              child: Text(
                news.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 底部信息
            Row(
              children: [
                Icon(Icons.chat_bubble_outline, size: 12, color: textColorSecondary),
                const SizedBox(width: 4),
                Text(
                  '${news.commentCount}',
                  style: TextStyle(color: textColorSecondary, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  news.author,
                  style: TextStyle(color: textColorTertiary, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              news.pubDate,
              style: TextStyle(color: textColorTertiary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}