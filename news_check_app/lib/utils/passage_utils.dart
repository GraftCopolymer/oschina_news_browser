import 'package:markdown/markdown.dart' as md;

enum ContentType { html, markdown }

class TocEntry {
  final String id;
  final String text;
  final int level;
  TocEntry({required this.id, required this.text, required this.level});
}

class PassageUtils {
  static ContentType detectType(String content) {
    // 匹配 <p> 标签（包括带属性的 <p ...>）或 </p> 结束标签
    final pTagRegex = RegExp(r'<(?:p(?:\s+[^>]+)?|/p)>', caseSensitive: false);

    if (pTagRegex.hasMatch(content)) {
      return ContentType.html;
    }

    // 否则视为 Markdown
    return ContentType.markdown;
  }

  /// 统一入口：检测内容类型 → 若为 Markdown 则转 HTML → 包裹为完整 WebView HTML
  ///
  /// [isDark] 由调用方传入（例如 Get.isDarkMode），决定 WebView 内配色，
  /// 避免 WebView 跟随系统偏好导致 App 手动切换后不一致。
  /// 返回 (HTML, TOC entries)。
  static (String html, List<TocEntry> toc) wrapBodyForWebView({
    required String title,
    required String author,
    required String pubDate,
    required String body,
    required bool isDark,
    double fontSize = 16,
    double lineSpacing = 1.75,
  }) {
    final htmlBody = detectType(body) == ContentType.markdown
        ? md.markdownToHtml(body)
        : body;
    final (enhancedBody, toc) = enhanceHtmlWithToc(htmlBody);
    final wrapped = htmlWrap(
      title: title,
      author: author,
      pubDate: pubDate,
      body: enhancedBody,
      isDark: isDark,
      fontSize: fontSize,
      lineSpacing: lineSpacing,
    );
    return (wrapped, toc);
  }

  /// 包裹为完整 HTML 页面，[isDark] 控制配色而非 @media query
  static String htmlWrap({
    String title = '',
    required String author,
    required String pubDate,
    required String body,
    bool isDark = false,
    double fontSize = 16,
    double lineSpacing = 1.75,
    bool isSepia = false,
  }) {
    final bgColor = isSepia ? '#F5E6C8' : (isDark ? '#121212' : '#ffffff');
    final textColor = isSepia ? '#3E2E1A' : (isDark ? '#e0e0e0' : '#1e293b');
    final metaColor = isSepia ? '#6B5D4D' : (isDark ? '#94a3b8' : '#64748b');
    final hrColor = isDark ? '#334155' : '#e2e8f0';
    final codeBg = isDark ? '#1e293b' : '#f1f5f9';
    final codeBorder = isDark ? '#475569' : '#cbd5e1';
    final linkColor = isDark ? '#67e8f9' : '#0d9488';
    final blockquoteBorder = isDark ? '#14b8a6' : '#0d9488';
    final blockquoteBg = isDark ? '#1e293b' : '#f0fdfa';

    // isSepia 覆盖 isDark 的配色
    String finalBg, finalText, finalMeta;
    if (isSepia) {
      finalBg = '#F5E6C8'; finalText = '#3E2E1A'; finalMeta = '#6B5D4D';
    } else if (isDark) {
      finalBg = '#121212'; finalText = '#e0e0e0'; finalMeta = '#94a3b8';
    } else {
      finalBg = '#ffffff'; finalText = '#1e293b'; finalMeta = '#64748b';
    }

    return """
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=3.0">
        <style>
          :root {
            --font-size: ${fontSize}px;
            --line-height: ${lineSpacing};
            --bg-color: $finalBg;
            --text-color: $finalText;
            --meta-color: $finalMeta;
            --hr-color: $hrColor;
            --code-bg: $codeBg;
            --code-border: $codeBorder;
            --link-color: $linkColor;
            --blockquote-border: $blockquoteBorder;
            --blockquote-bg: $blockquoteBg;
          }
          * { box-sizing: border-box; }
          body {
            font-family: -apple-system, 'PingFang SC', 'Noto Sans CJK SC', sans-serif;
            font-size: var(--font-size);
            line-height: var(--line-height);
            word-wrap: break-word;
            padding: 16px;
            margin: 0;
            background-color: var(--bg-color);
            color: var(--text-color);
          }
          h1 { font-size: calc(var(--font-size) * 1.375); margin: 16px 0 8px; font-weight: 700; line-height: 1.3; }
          h2 { font-size: calc(var(--font-size) * 1.1875); margin: 20px 0 8px; font-weight: 600; }
          h3 { font-size: calc(var(--font-size) * 1.0625); margin: 16px 0 6px; font-weight: 600; }
          p { margin: 10px 0; }
          a { color: var(--link-color); text-decoration: none; }
          a:hover { text-decoration: underline; }
          img { max-width: 100%; height: auto; display: block; margin: 12px auto; border-radius: 8px; cursor: pointer; }
          hr { border: none; height: 1px; background-color: var(--hr-color); margin: 20px 0; }
          pre { background-color: var(--code-bg); border: 1px solid var(--code-border); border-radius: 8px; padding: 14px; overflow-x: auto; font-size: calc(var(--font-size) * 0.875); line-height: 1.5; white-space: pre-wrap; word-wrap: break-word; }
          code { font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace; font-size: calc(var(--font-size) * 0.875); background-color: var(--code-bg); padding: 2px 6px; border-radius: 4px; }
          pre code { background: none; padding: 0; border-radius: 0; }
          blockquote { margin: 12px 0; padding: 10px 16px; border-left: 4px solid var(--blockquote-border); background-color: var(--blockquote-bg); border-radius: 0 6px 6px 0; }
          table { border-collapse: collapse; width: 100%; margin: 12px 0; }
          th, td { border: 1px solid var(--hr-color); padding: 8px 12px; text-align: left; }
          th { background-color: var(--code-bg); font-weight: 600; }
          ul, ol { padding-left: 24px; margin: 8px 0; }
          li { margin: 4px 0; }
          .meta { color: var(--meta-color); display: flex; justify-content: space-between; font-size: calc(var(--font-size) * 0.875); margin-bottom: 4px; }
        </style>
      </head>
      <body>
        ${title.isEmpty ? '' : '<h1>$title</h1>'}
        <div class="meta">
          <span>作者: $author</span>
          <span>$pubDate</span>
        </div>
        <hr/>
        $body
      </body>
      </html>
    """;
  }

  /// 用来包裹 Markdown 文章（已废弃，保留仅用于过渡参考）
  @Deprecated('使用 wrapBodyForWebView 代替')
  static String markdownWrap({
    required String title,
    required String author,
    required String pubDate,
    required String body,
  }) {
    return [
      "# $title",
      "> 作者: $author -- $pubDate",
      "---",
      body,
    ].join('\n');
  }

  /// 统计有效阅读字符数（去掉 HTML 标签后的非空白字符）
  static int countReadableChars(String htmlOrMarkdown) {
    final stripped = htmlOrMarkdown.replaceAll(RegExp(r'<[^>]*>'), '');
    return stripped.replaceAll(RegExp(r'\s'), '').length;
  }

  /// 为 HTML 中的 h1/h2/h3 添加锚点 id，同时返回标题列表
  static (String html, List<TocEntry> toc) enhanceHtmlWithToc(String body) {
    final entries = <TocEntry>[];
    int index = 0;
    final result = body.replaceAllMapped(
      RegExp(r'<h([1-3])([^>]*)>(.*?)</h\1>', caseSensitive: false, dotAll: true),
      (match) {
        final level = int.parse(match.group(1)!);
        final attrs = match.group(2)!;
        final text = match.group(3)!;
        // 去掉已有 id 避免冲突
        final cleanAttrs = attrs.replaceAll(
          RegExp(r'\bid\s*=\s*"[^"]*"', caseSensitive: false), '');
        final id = 'toc-$index';
        entries.add(TocEntry(id: id, text: text.replaceAll(RegExp(r'<[^>]*>'), ''), level: level));
        index++;
        return '<h$level$cleanAttrs id="$id">$text</h$level>';
      },
    );
    return (result, entries);
  }

  /// 从 HTML 中提取所有图片 URL
  static List<String> extractImageUrls(String html) {
    final regex = RegExp(r'<img[^>]+src="([^">]+)"');
    return regex.allMatches(html).map((m) => m.group(1)!).toList();
  }

  // 统一的图片点击 JS 注入脚本
  static const String imageClickJs = """
    (function() {
      var imgs = document.getElementsByTagName('img');
      var ratio = window.devicePixelRatio || 1;
      for (var i = 0; i < imgs.length; i++) {
        imgs[i].onclick = function() {
          var rect = this.getBoundingClientRect();
          var data = {
            src: this.src,
            x: rect.left * ratio,
            y: rect.top * ratio,
            width: rect.width * ratio,
            height: rect.height * ratio
          };
          ImageHeroApp.postMessage(JSON.stringify(data));
        };
      }
    })();
  """;
}
