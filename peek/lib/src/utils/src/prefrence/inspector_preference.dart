import 'ins_preference.dart';
import 'peek_preference.dart';

const String _inspector = 'inspector';

/// inspector 偏好
class InspectorPreference extends InsPreference {
  static const String _banner = 'banner';

  @override
  String get prefix => _inspector;

  @override
  Set<String> get allowList => {'$key$_banner'};

  /// 设置 banner 显示
  bool get debugAllowBannerOverride => prefs.getBool('$key$_banner') ?? true;

  /// 设置 banner 显示
  Future<void> setDebugAllowBannerOverride(bool value) => prefs.setBool(
        '$key$_banner',
        value,
      );
}
