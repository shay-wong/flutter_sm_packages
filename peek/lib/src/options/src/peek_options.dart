import '../../widgets/src/tiles/peek_tile.dart';
import 'entry_options.dart';
import 'inspector_options.dart';
import 'menu_options.dart';
import 'route_options.dart';

///VoidCallback from logs
typedef LogCallback = void Function(String message, {bool isError});

/// 全局选项
class PeekOptions {
  // ignore: public_member_api_docs
  const PeekOptions({
    this.enable = true,
    this.enableLog = false,
    this.entryOptions = const EntryOptions(),
    this.menuOptions = const MenuOptions(),
    this.routeOptions = const RouteOptions(),
    this.inspectorOptions = const InspectorOptions(),
    this.customTiles = const [],
    this.logCallback,
  });

  /// 自定义选项
  final List<PeekTile> customTiles;

  /// 是否启用
  final bool enable;

  /// 是否启用日志
  final bool enableLog;

  /// 入口选项
  final EntryOptions entryOptions;

  /// 日志回调
  final LogCallback? logCallback;

  /// 菜单选项
  final MenuOptions menuOptions;

  /// 路由选项
  final RouteOptions routeOptions;

  /// 调试器选项
  final InspectorOptions inspectorOptions;
}
