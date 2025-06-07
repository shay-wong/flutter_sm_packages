import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../peek.dart';
import 'pages/peek_page.dart';
import 'utils/src/logger.dart';
import 'widgets/src/peek_alert.dart';
import 'widgets/src/peek_overlay_entry.dart';

/// 调试器
class Peek extends StatefulWidget {
  // ignore: public_member_api_docs
  Peek({
    required Widget? child,
    PeekOptions? options,
  })  : child = child ?? const SizedBox.shrink(),
        options = options ?? const PeekOptions(),
        super(key: _globalKey);

  // ignore: public_member_api_docs
  static final _globalKey = GlobalKey<_PeekState>();

  /// 入口是否显示
  static bool get isShow => _globalKey.currentState?.isShowEntry ?? false;

  // ignore: public_member_api_docs
  final Widget child;

  /// 调试选项
  final PeekOptions options;

  @override
  State<Peek> createState() => _PeekState();

  /// overlay 构建
  static TransitionBuilder? builder({
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

  /// 初始化
  static Future<void> initialize() async => _globalKey.currentState?.initialize();

  /// 切换入口显示
  static void toggle() => _globalKey.currentState?.toggleEntry();

  /// 显示主页显示
  static void toggleHome() => _globalKey.currentState?.toggleHome();
}

class _PeekState extends State<Peek> {
  /// 是否显示 peek 入口
  bool isShowEntry = false;

  /// 是否显示主页
  bool isShowHome = false;

  OverlayEntry? peekPage;

  static final _globalKey = GlobalKey<PeekEntryState>();

  late final PeekOverlayEntry _overlayEntry = PeekOverlayEntry(
    builder: (context) {
      return PeekEntry(
        key: _globalKey,
        options: widget.options.entryOptions.merge(
          onPressed: toggleHome,
        ),
        menuOptions: widget.options.menuOptions,
      );
    },
  );

  final _overlayKey = GlobalKey<OverlayState>();

  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    Logger.debug('Peek build');
    var child = widget.child;

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

      // 判断是否有 Directionality，没有的话添加设置默认的 textDirection 为 ltr
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

  Future<void> hideEntry() async {
    if (isShowEntry) {
      late PeekOverlayEntry alert;
      alert = PeekOverlayEntry(
        builder: (context) {
          return PeekAlert(
            title: '关闭入口',
            cancel: '关闭',
            confirm: '取消',
            onCancel: () {
              hideHome();
              alert.remove();
              _overlayEntry.remove();
              isShowEntry = false;
              PeekPreference.instance.options.setShowEntry(false);
            },
            onDismiss: () => alert.remove(),
            onConfirm: () => alert.remove(),
          );
        },
      );
      _overlayKey.currentState?.insert(alert);
    }
  }

  void hideHome() {
    if (isShowHome && peekPage != null) {
      peekPage!.remove();
      isShowHome = false;
    }
  }

  Future init() async {
    var isShow = widget.options.enable && widget.options.entryOptions.showEntry;
    final prefs = PeekPreference.instance;
    final isInit = _isInitialized;
    if (!isInit) {
      isShowEntry = _isInitialized;
      await initialize();
    }

    if (isShow && prefs.options.showEntry != null) {
      isShow = prefs.options.showEntry!;
    }

    if (!isInit) {
      isShow ? showEntry() : hideEntry();
    }

    WidgetsApp.debugAllowBannerOverride = prefs.inspector.debugAllowBannerOverride;
    if (!isInit) {
      // 重新组装应用程序
      WidgetsBinding.instance.reassembleApplication();
    }
  }

  /// 初始化
  Future<void> initialize() async {
    if (!_isInitialized) {
      await PeekPreference.instance.reloadCache();
      _isInitialized = true;
      Logger.debug('Peek init');
    }
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  void showEntry() {
    if (!isShowEntry) {
      _overlayKey.currentState?.insert(_overlayEntry);
      isShowEntry = true;
      PeekPreference.instance.options.setShowEntry(true);
    }
  }

  void showHome() {
    if (!isShowHome) {
      _overlayKey.currentState?.insert(peekPage!, below: _overlayEntry);
      isShowHome = true;
    }
  }

  /// 切换
  void toggleEntry() {
    isShowEntry ? hideEntry() : showEntry();
  }

  void toggleHome() {
    peekPage ??= OverlayEntry(
      builder: (context) => PeekPage(
        options: widget.options,
        customTiles: widget.options.customTiles,
        onEntryOptionsChanged: () {
          _globalKey.currentState?.toggleHide();
        },
      ),
    );
    if (isShowHome) {
      hideHome();
    } else {
      showHome();
    }
  }
}
