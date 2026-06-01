enum ContentType { html, markdown }

class PassageUtils {
  static ContentType detectType(String content) {
    // 匹配 <p> 标签（包括带属性的 <p ...>）或 </p> 结束标签
    // < 表示开始，(?:...) 是非捕获分组
    // p(?:\s+[^>]+)? 匹配 p 字母及其后面可能跟随的空格和属性
    // |/p 匹配闭合标签 /p
    final pTagRegex = RegExp(r'<(?:p(?:\s+[^>]+)?|/p)>', caseSensitive: false);

    if (pTagRegex.hasMatch(content)) {
      return ContentType.html;
    }

    // 否则视为 Markdown
    return ContentType.markdown;
  }

  /// 用来包裹 HTML 文章
  static String htmlWrap({
    required String title,
    required String author,
    required String pubDate,
    required String body,
  }) {
    return """
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="color-scheme" content="light dark">
        <style>
          img { max-width: 100%; height: auto; display: block; margin: 10px auto; }
          body { word-wrap: break-word; padding: 12px; font-family: sans-serif; line-height: 1.6; }
          .meta { color: grey; display: flex; justify-content: space-between; font-size: 14px; }
          h1 { font-size: 22px; margin-bottom: 10px; }
          /* 使用 CSS 媒体查询或者直接根据变量生成样式 */
          @media (prefers-color-scheme: dark) {
            body { 
              background-color: #121212; 
              color: #e0e0e0; 
            }
          }
        </style>
      </head>
      <body>
        <h1>$title</h1>
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

  /// 用来包裹 Markdown 文章
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
