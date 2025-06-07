import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../peek.dart';
import 'peek_menu_item.dart';

const _kDefaultDimension = 50.0;

/// 菜单控制器
class PeekMenuController {
  /// 菜单控制器
  final _menuController = MenuController();

  /// 是否已释放
  var _disposed = false;

  /// 打开菜单
  void open() {
    _menuController.open();
  }

  /// 关闭菜单
  Future<void> close() async {
    final futures = <TickerFuture>[];
    while (_animationControllers.isNotEmpty) {
      final controller = _animationControllers.removeLast();
      futures.add(
        _disposed ? TickerFuture.complete() : controller.reverse(),
      );
    }
    await Future.wait(futures);
    _menuController.close();
  }

  final List<AnimationController> _animationControllers = [];

  /// 是否打开菜单
  bool get isOpen => _menuController.isOpen;

  /// 释放
  void dispose() {
    _disposed = true;
    _animationControllers.clear();
  }
}

/// 菜单
class PeekMenu extends StatefulWidget {
  // ignore: public_member_api_docs
  const PeekMenu({
    required this.options,
    required this.menuOptions,
    required this.child,
    required this.menuController,
    required this.position,
    super.key,
  });

  /// 选项
  final EntryOptions options;

  /// 菜单
  final MenuOptions menuOptions;

  /// 子组件
  final Widget child;

  /// 菜单控制器
  final PeekMenuController menuController;

  /// 是否
  final Offset position;

  @override
  State<PeekMenu> createState() => _PeekMenuState();
}

class _PeekMenuState extends State<PeekMenu> {
  /// 大小
  double get dimension => widget.options.dimension ?? _kDefaultDimension;

  @override
  void initState() {
    super.initState();

    widget.menuController._disposed = false;
  }

  @override
  void dispose() {
    widget.menuController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      ...widget.menuOptions.items,
      if (PeekPreference.instance.menu.items.contains(MenuItemType.close))
        PeekMenuItem(
          icon: const Icon(Icons.close_rounded),
          color: Colors.redAccent,
          dimension: dimension,
          onPressed: () {
            widget.menuController.close();
            Peek.toggle();
          },
          tooltip: '关闭入口',
        ),
      if (PeekPreference.instance.menu.items.contains(MenuItemType.inspector))
        PeekMenuItem(
          icon: const Icon(Icons.touch_app_rounded),
          color: Colors.lightBlueAccent,
          dimension: dimension,
          onPressed: () {
            WidgetsBinding.instance.debugShowWidgetInspectorOverride =
                !WidgetsBinding.instance.debugShowWidgetInspectorOverride;
            widget.menuController.close();
          },
          tooltip: '显示小部件检查器',
        ),
    ];

    final menuChildren = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final delay = 80.ms * i;
      menuChildren.add(
        Animate(
          onInit: widget.menuController._animationControllers.add,
          delay: delay,
          effects: [
            FadeEffect(
              duration: 250.ms,
              delay: 20.ms,
              begin: 0,
              end: 1,
            ),
            const ShimmerEffect(),
            const MoveEffect(
              begin: Offset(0, -16),
              curve: Curves.easeOutQuad,
            ),
          ],
          child: item,
        ),
      );
    }

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        fixedSize: WidgetStatePropertyAll(Size.fromWidth(dimension)),
        padding: WidgetStatePropertyAll(
          EdgeInsetsDirectional.symmetric(horizontal: (dimension - 48) / 2).copyWith(bottom: 20),
        ),
      ),
      controller: widget.menuController._menuController,
      menuChildren: menuChildren,
      child: widget.child,
    );
  }
}
