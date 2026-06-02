import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_check_app/utils/error_logger.dart';

void main() {
  group('logError', () {
    test('outputs tag and exception message', () {
      final lines = <String>[];
      // 捕获 debugPrint 输出
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) lines.add(message);
      };

      logError('测试错误', Exception('出错了'), StackTrace.current);

      debugPrint = debugPrint; // 还原

      expect(lines.any((l) => l.contains('测试错误')), isTrue);
      expect(lines.any((l) => l.contains('Exception')), isTrue);
      expect(lines.any((l) => l.contains('出错了')), isTrue);
    });

    test('handles null stack trace', () {
      final lines = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) lines.add(message);
      };

      logError('null测试', 'simple string error', null);

      debugPrint = debugPrint;

      expect(lines.any((l) => l.contains('null测试')), isTrue);
      expect(lines.length, greaterThan(0));
    });
  });
}