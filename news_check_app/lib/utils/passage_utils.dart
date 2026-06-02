import 'package:markdown/markdown.dart' as md;

enum ContentType { html, markdown }

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
  static String wrapBodyForWebView({
    required String title,
    required String author,
    required String pubDate,
    required String body,
    required bool isDark,
  }) {
    // Markdown → HTML 转换
    final htmlBody = detectType(body) == ContentType.markdown
        ? md.markdownToHtml(body)
        : body;

    return htmlWrap(
      title: title,
      author: author,
      pubDate: pubDate,
      body: htmlBody,
      isDark: isDark,
    );
  }

  /// 包裹为完整 HTML 页面，[isDark] 控制配色而非 @media query
  static String htmlWrap({
    required String title,
    required String author,
    required String pubDate,
    required String body,
    bool isDark = false,
  }) {
    final bgColor = isDark ? '#121212' : '#ffffff';
    final textColor = isDark ? '#e0e0e0' : '#1e293b';
    final metaColor = isDark ? '#94a3b8' : '#64748b';
    final hrColor = isDark ? '#334155' : '#e2e8f0';
    final codeBg = isDark ? '#1e293b' : '#f1f5f9';
    final codeBorder = isDark ? '#475569' : '#cbd5e1';
    final linkColor = isDark ? '#67e8f9' : '#0d9488';
    final blockquoteBorder = isDark ? '#14b8a6' : '#0d9488';
    final blockquoteBg = isDark ? '#1e293b' : '#f0fdfa';

    return """
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=3.0">
        <style>
          * { box-sizing: border-box; }
          body {
            font-family: -apple-system, 'PingFang SC', 'Noto Sans CJK SC', sans-serif;
            font-size: 16px;
            line-height: 1.75;
            word-wrap: break-word;
            padding: 16px;
            margin: 0;
            background-color: $bgColor;
            color: $textColor;
          }
          h1 { font-size: 22px; margin: 16px 0 8px; font-weight: 700; line-height: 1.3; }
          h2 { font-size: 19px; margin: 20px 0 8px; font-weight: 600; }
          h3 { font-size: 17px; margin: 16px 0 6px; font-weight: 600; }
          p { margin: 10px 0; }
          a { color: $linkColor; text-decoration: none; }
          a:hover { text-decoration: underline; }
          img {
            max-width: 100%; height: auto;
            display: block; margin: 12px auto;
            border-radius: 8px;
            cursor: pointer;
          }
          hr {
            border: none;
            height: 1px;
            background-color: $hrColor;
            margin: 20px 0;
          }
          pre {
            background-color: $codeBg;
            border: 1px solid $codeBorder;
            border-radius: 8px;
            padding: 14px;
            overflow-x: auto;
            font-size: 14px;
            line-height: 1.5;
            white-space: pre-wrap;
            word-wrap: break-word;
          }
          code {
            font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace;
            font-size: 14px;
            background-color: $codeBg;
            padding: 2px 6px;
            border-radius: 4px;
          }
          pre code {
            background: none;
            padding: 0;
            border-radius: 0;
          }
          blockquote {
            margin: 12px 0;
            padding: 10px 16px;
            border-left: 4px solid $blockquoteBorder;
            background-color: $blockquoteBg;
            border-radius: 0 6px 6px 0;
          }
          table {
            border-collapse: collapse;
            width: 100%;
            margin: 12px 0;
          }
          th, td {
            border: 1px solid $hrColor;
            padding: 8px 12px;
            text-align: left;
          }
          th { background-color: $codeBg; font-weight: 600; }
          ul, ol { padding-left: 24px; margin: 8px 0; }
          li { margin: 4px 0; }
          .meta {
            color: $metaColor;
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            margin-bottom: 4px;
          }
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
