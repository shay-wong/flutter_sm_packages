// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../../../peek.dart';

/// 日志
class Logger {
  /// 是否启用
  static bool enable = kDebugMode;

  /// 日志
  static LogCallback log = defaultLogWriterCallback;

  /// 调试
  static void debug(String message) => log.call(message);

  /// default logger from GetX
  static void defaultLogWriterCallback(String message, {bool isError = false}) {
    if (enable || isError) developer.log(message, name: 'Peek');
  }

  /// 错误
  static void error(String message) => log.call(message, isError: true);
}
