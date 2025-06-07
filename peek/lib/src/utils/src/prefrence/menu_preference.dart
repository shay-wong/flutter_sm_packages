import '../../../widgets/src/menu/peek_menu_item.dart';
import 'ins_preference.dart';
import 'peek_preference.dart';

const String _menu = 'menu';

/// menu 偏好
class MenuPreference extends InsPreference {
  static const String _items = 'items';
  @override
  Set<String> get allowList => {'$key$_items'};

  /// 菜单
  Set<MenuItemType> get items {
    return prefs
            .getStringList('$key$_items')
            ?.map((e) {
              final index = int.tryParse(e);
              if (index != null) {
                return MenuItemType.values[index];
              }
              return MenuItemType.unknown;
            })
            .where(
              (element) => element != MenuItemType.unknown,
            )
            .toSet() ??
        {};
  }

  set items(Set<MenuItemType> value) {
    prefs.setStringList(
      '$key$_items',
      value
          .map(
            (e) => e.index.toString(),
          )
          .toList(),
    );
  }

  /// 添加
  void addItem(MenuItemType type) {
    items = items..add(type);
  }

  /// 移除
  void removeItem(MenuItemType type) {
    items = items..remove(type);
  }

  @override
  String get prefix => _menu;
}
