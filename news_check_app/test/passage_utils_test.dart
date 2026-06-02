import 'package:flutter_test/flutter_test.dart';
import 'package:news_check_app/utils/passage_utils.dart';

void main() {
  group('PassageUtils', () {
    group('countReadableChars', () {
      test('strips HTML tags and whitespace', () {
        final html = '<p>Hello 世界</p>';
        expect(PassageUtils.countReadableChars(html), equals(7)); // "Hello世界" = 7
      });

      test('returns 0 for empty string', () {
        expect(PassageUtils.countReadableChars(''), equals(0));
      });

      test('returns 0 for only tags', () {
        expect(PassageUtils.countReadableChars('<p></p><br/>'), equals(0));
      });

      test('handles mixed content', () {
        final html = '<div><h1>标题</h1><p>一段<b>加粗</b>文字</p></div>';
        expect(PassageUtils.countReadableChars(html), equals(8)); // 标题 + 一段加粗文字
      });
    });

    group('detectType', () {
      test('detects HTML with <p> tag', () {
        expect(PassageUtils.detectType('<p>hello</p>'), equals(ContentType.html));
      });

      test('detects HTML with <p> with attributes', () {
        expect(PassageUtils.detectType('<p class="test">hello</p>'), equals(ContentType.html));
      });

      test('detects markdown by absence of <p>', () {
        expect(PassageUtils.detectType('# Hello\n\nWorld'), equals(ContentType.markdown));
      });
    });

    group('enhanceHtmlWithToc', () {
      test('adds id to h1 and returns entry', () {
        final (html, toc) = PassageUtils.enhanceHtmlWithToc('<h1>Title</h1>');
        expect(html, contains('id="toc-0"'));
        expect(toc.length, equals(1));
        expect(toc[0].text, equals('Title'));
        expect(toc[0].level, equals(1));
      });

      test('adds ids to all heading levels', () {
        final (html, toc) = PassageUtils.enhanceHtmlWithToc(
          '<h1>A</h1><h2>B</h2><h3>C</h3>',
        );
        expect(toc.length, equals(3));
        expect(toc[0].level, equals(1));
        expect(toc[1].level, equals(2));
        expect(toc[2].level, equals(3));
      });

      test('returns empty list for no headings', () {
        final (html, toc) = PassageUtils.enhanceHtmlWithToc('<p>text</p>');
        expect(toc, isEmpty);
        expect(html, equals('<p>text</p>'));
      });
    });

    group('extractImageUrls', () {
      test('extracts single image URL', () {
        final urls = PassageUtils.extractImageUrls('<img src="https://example.com/a.jpg">');
        expect(urls, equals(['https://example.com/a.jpg']));
      });

      test('extracts multiple image URLs', () {
        final urls = PassageUtils.extractImageUrls(
          '<img src="a.jpg"><img src="b.png">',
        );
        expect(urls, equals(['a.jpg', 'b.png']));
      });

      test('returns empty list when no images', () {
        expect(PassageUtils.extractImageUrls('<p>no image</p>'), isEmpty);
      });
    });

    group('htmlWrap', () {
      test('wraps body in complete HTML with title', () {
        final html = PassageUtils.htmlWrap(
          title: 'Test',
          author: 'Me',
          pubDate: '2026-01-01',
          body: '<p>content</p>',
        );
        expect(html, contains('<h1>Test</h1>'));
        expect(html, contains('作者: Me'));
        expect(html, contains('2026-01-01'));
        expect(html, contains('<p>content</p>'));
        expect(html, contains('</html>'));
      });

      test('dark mode sets dark background', () {
        final html = PassageUtils.htmlWrap(
          author: 'A', pubDate: 'D', body: 'B', isDark: true,
        );
        expect(html, contains('--bg-color: #121212'));
      });

      test('light mode sets light background', () {
        final html = PassageUtils.htmlWrap(
          author: 'A', pubDate: 'D', body: 'B', isDark: false,
        );
        expect(html, contains('--bg-color: #ffffff'));
      });
    });
  });
}