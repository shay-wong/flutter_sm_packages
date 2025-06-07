import 'package:shared_preferences/shared_preferences.dart';

import 'inspector_preference.dart';
import 'menu_preference.dart';
import 'options_preference.dart';

/// 偏好
final class PeekPreference {
  /// 单例
  factory PeekPreference() => _instance;

  PeekPreference._();

  static final PeekPreference _instance = PeekPreference._();

  /// 单例
  static PeekPreference get instance => _instance;

  /// Cache containing in-memory data.
  final Map<String, Object?> _cache = <String, Object?>{};

  /// Options that define cache behavior.
  late final SharedPreferencesWithCacheOptions _cacheOptions = SharedPreferencesWithCacheOptions(
    allowList: {
      ...options.allowList,
      ...inspector.allowList,
      ...menu.allowList,
    },
  );

  /// Async access directly to the platform.
  ///
  /// Methods called through [_platformMethods] will NOT update the cache.
  final SharedPreferencesAsync _platformMethods = SharedPreferencesAsync();

  final _inspector = InspectorPreference();
  final _menu = MenuPreference();

  final _options = OptionsPreference();

  /// 检查偏好
  InspectorPreference get inspector => _instance._inspector;

  /// 菜单偏好
  MenuPreference get menu => _instance._menu;

  /// 选项偏好
  OptionsPreference get options => _instance._options;
}

/// shared preferences extension
extension PeekPreferenceExt on PeekPreference {
  /// Returns all keys in the cache.
  Set<String> get keys => _cache.keys.toSet();

  /// Clears cache and platform preferences that match filter options.
  Future<void> clear() async {
    _cache.clear();
    return _platformMethods.clear(allowList: _cacheOptions.allowList);
  }

  /// Returns true if cache contains the given [key].
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  bool containsKey(String key) {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    return _cache.containsKey(key);
  }

  /// Reads a value of any type from the cache.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  Object? get(String key) {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    return _cache[key];
  }

  /// Reads a value from the cache, throwing a [TypeError] if the value is not a
  /// bool.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  bool? getBool(String key) {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    return get(key) as bool?;
  }

  /// Reads a value from the cache, throwing a [TypeError] if the value is not a
  /// double.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  double? getDouble(String key) {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    return get(key) as double?;
  }

  /// Reads a value from the cache, throwing a [TypeError] if the value is not
  /// an int.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  int? getInt(String key) {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    return get(key) as int?;
  }

  /// Reads a value from the cache, throwing a [TypeError] if the value is not a
  /// String.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  String? getString(String key) {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    return get(key) as String?;
  }

  /// Reads a list of string values from the cache, throwing an
  /// exception if it's not a string list.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  List<String>? getStringList(String key) {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    // Make a copy of the list so that later mutations won't propagate
    return (_cache[key] as List<Object?>?)?.cast<String>().toList();
  }

  /// Updates cache with latest values from platform.
  ///
  /// This should be called before reading any values if the values may have
  /// been changed by anything other than this cache instance,
  /// such as from another isolate or native code that changes the underlying
  /// preference storage directly.
  Future<void> reloadCache() async {
    _cache
      ..clear()
      ..addAll(await _platformMethods.getAll(allowList: _cacheOptions.allowList));
  }

  /// Removes an entry from cache and platform.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  Future<void> remove(String key) async {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    _cache.remove(key);
    return _platformMethods.remove(key);
  }

  /// Saves a boolean [value] to the cache and platform.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  Future<void> setBool(String key, bool value) async {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    _cache[key] = value;
    return _platformMethods.setBool(key, value);
  }

  /// Saves a double [value] to the cache and platform.
  ///
  /// On platforms that do not support storing doubles,
  /// the value will be stored as a float instead.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  Future<void> setDouble(String key, double value) async {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    _cache[key] = value;
    return _platformMethods.setDouble(key, value);
  }

  /// Saves an integer [value] to the cache and platform.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  Future<void> setInt(String key, int value) async {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    _cache[key] = value;
    return _platformMethods.setInt(key, value);
  }

  /// Saves a string [value] to the cache and platform.
  ///
  /// Note: Due to limitations on some platforms,
  /// values cannot start with the following:
  ///
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu'
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  Future<void> setString(String key, String value) async {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    _cache[key] = value;
    return _platformMethods.setString(key, value);
  }

  /// Saves a list of strings [value] to the cache and platform.
  ///
  /// Throws an [ArgumentError] if [key] is not in this instance's filter.
  Future<void> setStringList(String key, List<String> value) async {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    _cache[key] = value;
    return _platformMethods.setStringList(key, value);
  }

  bool _isValidKey(String key) {
    return _cacheOptions.allowList?.contains(key) ?? true;
  }
}
