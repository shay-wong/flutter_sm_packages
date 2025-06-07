import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/src/prefrence/peek_preference.dart';
import '../widgets/src/menu/peek_menu_item.dart';
import '../widgets/src/peek_scaffold.dart';

/// 列表元祖
typedef ListTuple = (
  IconData icon,
  String title,
  bool Function(),
  void Function(bool),
);

/// 菜单
class MenuPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const MenuPage({
    super.key,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<ListTuple> get _listTiles => [
        (
          Icons.close_rounded,
          '关闭入口',
          () => PeekPreference.instance.menu.items.contains(MenuItemType.close),
          _dropCloseMenu,
        ),
        (
          Icons.touch_app_rounded,
          '显示小部件检查器',
          () => PeekPreference.instance.menu.items.contains(MenuItemType.inspector),
          _dropWidgetInspectorMenu,
        ),
      ];

  void _dropCloseMenu(bool value) {
    setState(() {
      if (value) {
        PeekPreference.instance.menu.addItem(MenuItemType.close);
      } else {
        PeekPreference.instance.menu.removeItem(MenuItemType.close);
      }
    });
  }

  void _dropWidgetInspectorMenu(bool value) {
    setState(() {
      if (value) {
        PeekPreference.instance.menu.addItem(MenuItemType.inspector);
      } else {
        PeekPreference.instance.menu.removeItem(MenuItemType.inspector);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PeekScaffold(
      titleText: 'Menu',
      body: ListView.builder(
        itemBuilder: (context, index) {
          final (icon, title, value, changed) = _listTiles[index];
          return ListTile(
            leading: Icon(icon),
            title: Text(title),
            trailing: CupertinoSwitch(
              value: value(),
              onChanged: changed,
            ),
            onTap: () {
              changed(!value());
            },
          );
        },
        itemCount: _listTiles.length,
      ),
    );
  }
}
