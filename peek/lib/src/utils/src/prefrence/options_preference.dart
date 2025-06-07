import 'ins_preference.dart';
import 'peek_preference.dart';

const String _options = 'options';

/// 选项偏好
class OptionsPreference extends InsPreference {
  static const String _adsorb = 'adsorb';
  static const String _autoHide = 'autoHide';
  static const String _dx = 'distance_x';
  static const String _dy = 'distance_y';
  static const String _fold = 'fold';
  static const String _showEntry = 'showEntry';

  /// 获取是否吸附
  bool? get adsorb => prefs.getBool('$key$_adsorb');

  @override
  Set<String> get allowList => {
        '$key$_showEntry',
        '$key$_adsorb',
        '$key$_autoHide',
        '$key$_fold',
        '$key$_dx',
        '$key$_dy',
      };

  /// 获取是否自动隐藏
  bool? get autoHide => prefs.getBool('$key$_autoHide');

  /// 入口位置 x
  double? get dx => prefs.getDouble('$key$_dx');

  /// 入口位置 y
  double? get dy => prefs.getDouble('$key$_dy');

  /// 获取是否收起
  bool? get fold => prefs.getBool('$key$_fold');

  @override
  String get prefix => _options;

  /// 获取入口
  bool? get showEntry => prefs.getBool('$key$_showEntry');

  /// 设置是否吸附
  Future<void> setAdsorb(bool value) => prefs.setBool('$key$_adsorb', value);

  /// 设置是否自动隐藏
  Future<void> setAutoHide(bool value) => prefs.setBool('$key$_autoHide', value);

  /// 设置入口位置 x
  Future<void> setDx(double value) => prefs.setDouble('$key$_dx', value);

  /// 设置入口位置 y
  Future<void> setDy(double value) => prefs.setDouble('$key$_dy', value);

  /// 设置是否收起
  Future<void> setFold(bool value) => prefs.setBool('$key$_fold', value);

  /// 设置入口
  Future<void> setShowEntry(bool value) => prefs.setBool('$key$_showEntry', value);
}
