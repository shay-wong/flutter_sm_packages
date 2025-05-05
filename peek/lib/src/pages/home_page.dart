import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../options/src/peek_options.dart';
import '../widgets/peek_grid_tile.dart';
import '../widgets/peek_tile.dart';
import 'route_page.dart';

/// 调试页面
class HomePage extends StatelessWidget {
  // ignore: public_member_api_docs
  const HomePage({
    super.key,
    this.options = const PeekOptions(),
    this.onClose,
    this.customTiles = const [],
  });

  /// 选项
  final PeekOptions options;

  /// 关闭回调
  final VoidCallback? onClose;

  /// 自定义选项
  final List<PeekTile> customTiles;

  static const _defaultTiles = <PeekTile>[
    PeekGridTile(
      footer: Text('Route', textAlign: TextAlign.center),
      child: Icon(Icons.route_outlined),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('调试'),
          leading: CloseButton(onPressed: onClose),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final tile = index < customTiles.length
                      ? customTiles[index]
                      : _defaultTiles[index - customTiles.length];
                  return InkWell(
                    onTap: tile.onTap ??
                        () {
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
                    child: GridTile(
                      footer: tile.footer,
                      child: tile.child ?? const SizedBox.shrink(),
                    ),
                  );
                },
                itemCount: customTiles.length + _defaultTiles.length,
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
