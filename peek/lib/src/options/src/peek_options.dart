import '../../widgets/tiles/peek_tile.dart';
import 'entry_options.dart';
import 'route_options.dart';

/// 全局选项
class PeekOptions {
  // ignore: public_member_api_docs
  const PeekOptions({
    this.enable = true,
    this.entryOptions = const EntryOptions(),
    this.routeOptions = const RouteOptions(),
    this.customTiles = const [],
  });

  /// 是否启用
  final bool enable;

  /// 自定义选项
  final List<PeekTile> customTiles;

  /// 入口选项
  final EntryOptions entryOptions;

  /// 路由线下
  final RouteOptions routeOptions;
}
