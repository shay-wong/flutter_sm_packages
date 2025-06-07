import '../../widgets/src/tiles/peek_tile.dart';
import 'entry_options.dart';
import 'menu_options.dart';
import 'route_options.dart';

/// 全局选项
class PeekOptions {
  // ignore: public_member_api_docs
  const PeekOptions({
    this.enable = true,
    this.entryOptions = const EntryOptions(),
    this.menuOptions = const MenuOptions(),
    this.routeOptions = const RouteOptions(),
    this.customTiles = const [],
  });

  /// 是否启用
  final bool enable;

  /// 自定义选项
  final List<PeekTile> customTiles;

  /// 入口选项
  final EntryOptions entryOptions;

  /// 菜单选项
  final MenuOptions menuOptions;

  /// 路由选项
  final RouteOptions routeOptions;
}
