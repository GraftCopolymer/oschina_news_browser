import 'package:flutter_test/flutter_test.dart';
import 'package:news_check_app/utils/passage_utils.dart';
import 'package:news_check_app/models/models.dart';

void main() {
  test('utility modules are importable', () {
    expect(PassageUtils.countReadableChars('test'), isA<int>());
  });

  test('models are importable and constructable', () {
    final news = NewsSimple(
      id: 1,
      title: '测试',
      author: '作者',
      pubDate: '2026-01-01',
      type: '4',
      commentCount: 0,
    );
    expect(news.title, equals('测试'));

    final blog = BlogSimple(
      id: 2,
      title: '博客',
      author: '作者',
      pubDate: '2026-01-01',
      type: 1,
      commentCount: 5,
      authorid: 0,
    );
    expect(blog.title, equals('博客'));
  });

  test('TokenModel can be constructed', () {
    final model = TokenModel(sub: '42', exp: 9999999999);
    expect(model.sub, equals('42'));
    expect(model.exp, equals(9999999999));
  });
}