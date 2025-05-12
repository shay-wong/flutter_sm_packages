import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'options/src/peek_options.dart';
import 'pages/peek_page.dart';
import 'widgets/peek_entry.dart';
import 'widgets/peek_overlay_entry.dart';

/// 调试器
class Peek extends StatefulWidget {
  // ignore: public_member_api_docs, tighten_type_of_initializing_formals
  Peek({
    required Widget? child,
    PeekOptions? options,
  })  : child = child ?? const SizedBox.shrink(),
        options = options ?? const PeekOptions(),
        super(key: _globalKey);

  // ignore: public_member_api_docs
  static final _globalKey = GlobalKey<_PeekState>();

  // ignore: public_member_api_docs
  final Widget child;

  /// 调试选项
  final PeekOptions options;

  @override
  State<Peek> createState() => _PeekState();

  /// 初始化
  static TransitionBuilder? init({
    PeekOptions? options,
    TransitionBuilder? builder,
  }) {
    final enable = options?.enable ?? false;
    if (enable) {
      return (BuildContext context, Widget? child) {
        final peek = Peek(
          options: options,
          child: child,
        );
        if (builder != null) {
          return builder(context, peek);
        } else {
          return peek;
        }
      };
    } else {
      return builder;
    }
  }

  /// 切换入口显示
  static void toggle() => _globalKey.currentState?.toggleEntry();

  /// 显示主页显示
  static void toggleHome() => _globalKey.currentState?.toggleHome();

  /// 入口是否显示
  static bool get isShow => _globalKey.currentState?.isShowEntry ?? false;
}

class _PeekState extends State<Peek> {
  late PeekOverlayEntry _overlayEntry;
  OverlayEntry? peekPage;

  final _overlayKey = GlobalKey<OverlayState>();

  /// 是否显示主页
  // ignore: omit_obvious_property_types
  bool isShowHome = false;

  /// 是否显示 peek 入口
  // ignore: omit_obvious_property_types
  bool isShowEntry = false;

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    Widget child = widget.child;

    if (widget.options.enable) {
      child = Material(
        child: Overlay(
          key: _overlayKey,
          initialEntries: [
            PeekOverlayEntry(
              builder: (context) {
                return widget.child;
              },
            ),
            if (isShowEntry) _overlayEntry,
          ],
        ),
      );

      if (context.widget is! Directionality &&
          context.getElementForInheritedWidgetOfExactType<Directionality>() == null) {
        child = Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        );
      }
    }

    return child;
  }

  @override
  void initState() {
    super.initState();
    _overlayEntry = PeekOverlayEntry(
      builder: (context) => PeekEntry(
        options: widget.options.entryOptions.merge(
          onPressed: toggleHome,
          onLongPressed: () {
            debugPrint('关闭调试入口');
            hideEntry();
          },
        ),
      ),
    );

    isShowEntry = widget.options.entryOptions.showEntry;
  }

  void hideHome() {
    if (isShowHome && peekPage != null) {
      peekPage!.remove();
      isShowHome = false;
    }
  }

  void showHome() {
    if (!isShowHome) {
      _overlayKey.currentState?.insert(peekPage!, below: _overlayEntry);
      isShowHome = true;
    }
  }

  void toggleHome() {
    peekPage ??= OverlayEntry(
      builder: (context) => PeekPage(
        options: widget.options,
        onClose: hideHome,
        customTiles: widget.options.customTiles,
      ),
    );
    if (isShowHome) {
      hideHome();
    } else {
      showHome();
    }
  }

  void hideEntry() {
    if (isShowEntry) {
      hideHome();
      _overlayEntry.remove();
      isShowEntry = false;
    }
  }

  void showEntry() {
    if (!isShowEntry) {
      _overlayKey.currentState?.insert(_overlayEntry);
      isShowEntry = true;
    }
  }

  /// 切换
  void toggleEntry() {
    isShowEntry ? hideEntry() : showEntry();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<GlobalKey<OverlayState>>(
          'PeekOverlayKey',
          _overlayKey,
        ),
      )
      ..add(DiagnosticsProperty<OverlayEntry?>('peekPage', peekPage))
      ..add(DiagnosticsProperty<bool>('isShowHome', isShowHome))
      ..add(DiagnosticsProperty<bool>('isShowEntry', isShowEntry));
  }
}
