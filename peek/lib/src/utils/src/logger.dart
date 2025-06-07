// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:developer';

/// 日志
class Logger {
  /// 调试
  static void debug(String message) => log(message, name: 'Peek');
}
