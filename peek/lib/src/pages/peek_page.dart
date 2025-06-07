import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../peek.dart';
import '../widgets/src/peek_scaffold.dart';
import 'inspector_page.dart';
import 'menu_page.dart';
import 'route_page.dart';
import 'settings_page.dart';

/// 调试页面
class PeekPage extends StatelessWidget {
  // ignore: public_member_api_docs
  const PeekPage({
    super.key,
    this.options = const PeekOptions(),
    this.customTiles = const [],
    this.onEntryOptionsChanged,
  });

  /// 自定义选项
  final List<PeekTile> customTiles;

  /// 入口选项更改
  final VoidCallback? onEntryOptionsChanged;

  /// 选项
  final PeekOptions options;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return PeekScaffold(
            titleText: 'Peek',
            body: CustomScrollView(
              slivers: _buildSliversFromTiles(
                context,
                customTiles,
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建 slivers
  List<Widget> _buildSliversFromTiles(
    BuildContext context,
    List<PeekTile> tiles,
  ) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 512
        ? 4
        : width < 1024
            ? 6
            : 9;
    tiles = [...tiles, ..._defaultTiles(context)];
    final slivers = <Widget>[];
    var i = 0;

    while (i < tiles.length) {
      final currentType = tiles[i].runtimeType;
      final buffer = <PeekTile>[];

      // 收集连续的相同类型 tile
      while (i < tiles.length && tiles[i].runtimeType == currentType) {
        buffer.add(tiles[i]);
        i++;
      }

      if (currentType == PeekListTile) {
        slivers.add(
          SliverList(
            delegate: SliverChildListDelegate(
              buffer.map((tile) => tile).toList(),
            ),
          ),
        );
      } else if (currentType == PeekGridTile) {
        slivers.add(
          SliverGrid(
            delegate: SliverChildListDelegate(
              buffer.map((tile) => tile).toList(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        );
      }
    }

    return slivers;
  }

  /// 默认选项
  List<PeekTile> _defaultTiles(BuildContext context) {
    return <PeekTile>[
      PeekGridTile(
        icon: const Icon(Icons.troubleshoot_rounded),
        title: const Text(
          'Inspector',
        ),
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return const InspectorPage();
              },
            ),
          );
        },
      ),
      PeekGridTile(
        title: const Text(
          'Route',
          textAlign: TextAlign.center,
        ),
        icon: const Icon(
          Icons.route_outlined,
        ),
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return RoutePage(
                  options: options.routeOptions,
                );
              },
            ),
          );
        },
      ),
      PeekGridTile(
        title: const Text(
          'Menu',
          textAlign: TextAlign.center,
        ),
        icon: const Icon(
          Icons.menu_rounded,
        ),
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return const MenuPage();
              },
            ),
          );
        },
      ),
      PeekGridTile(
        title: const Text(
          'Settings',
          textAlign: TextAlign.center,
        ),
        icon: const Icon(
          Icons.settings_suggest_rounded,
        ),
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return SettingsPage(
                  options: options,
                  onEntryOptionsChanged: onEntryOptionsChanged,
                );
              },
            ),
          );
        },
      ),
    ];
  }
}
