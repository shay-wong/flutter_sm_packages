import 'peek_preference.dart';

const String _prefix = 'peek';

/// 偏好实例
abstract class InsPreference {
  /// 异步偏好
  PeekPreference get prefs => PeekPreference.instance;

  /// 键
  String get key => '$_prefix.$prefix.';

  /// 前缀
  String get prefix;

  /// 允许列表
  Set<String>? get allowList => null;
}
