import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';
import 'package:news_check_app/widgets/hero_page_route.dart';

/// 用于展示 Markdown 内容的博客
class CommonDetailMarkdown extends StatefulWidget {
  const CommonDetailMarkdown({super.key, required this.content});

  final String content;

  @override
  State<CommonDetailMarkdown> createState() => _CommonDetailMarkdownState();
}

class _CommonDetailMarkdownState extends State<CommonDetailMarkdown> {
  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: widget.content,
      imageBuilder: (uri, title, alt) {
        debugPrint("图片 URI: $uri");
        return GestureDetector(
          onTap: () {
            showHeroPhotoViewer(context, uri.toString());
          },
          child: Hero(
            tag: uri.toString(),
            child: Image.network(uri.toString()),
          ),
        );
      },
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        blockquoteDecoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.withAlpha(100) : Colors.grey[100],
          borderRadius: BorderRadius.circular(4),
          border: Border(left: BorderSide(color: Colors.blue, width: 4)),
        ),
        blockquote: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.grey[700],
          fontSize: 14,
        ),
        blockquotePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1.5, // 分隔线的粗细
              color: Colors.grey[300]!, // 分隔线的颜色
            ),
          ),
        ),
      ),
    );
  }
}
