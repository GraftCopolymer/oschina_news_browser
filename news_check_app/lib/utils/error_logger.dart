import 'package:flutter/foundation.dart';

/// 完整打印异常信息，包括错误详情和调用栈
///
/// [tag] 用于标识异常来源
/// [e] 是捕获的异常对象（通常是 Exception 或 Error）
/// [st] 是异常的调用栈（StackTrace）
void logError(String tag, dynamic e, StackTrace? st) {
  debugPrint('═══════════════════════════════════════');
  debugPrint('❌ ERROR: $tag');
  debugPrint('   Exception: $e');
  debugPrint('   Type: ${e.runtimeType}');
  if (st != null) {
    debugPrint('   StackTrace:');
    // 格式化缩进，便于阅读
    for (final line in st.toString().split('\n')) {
      if (line.trim().isNotEmpty) {
        debugPrint('     $line');
      }
    }
  }
  debugPrint('═══════════════════════════════════════');
}