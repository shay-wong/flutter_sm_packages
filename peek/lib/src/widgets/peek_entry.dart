import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../options/src/entry_options.dart';

const _kDefaultSize = 50.0;

/// 调试器
class PeekEntry extends StatefulWidget {
  /// Constructor
  const PeekEntry({super.key, this.options = const EntryOptions()});

  /// 选项
  final EntryOptions options;

  @override
  State<PeekEntry> createState() => _PeekEntryState();
}

class _PeekEntryState extends State<PeekEntry>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  /// 是否动画
  var _isAnimated = false;

  /// 是否拖动
  var _isDragging = false;

  /// 是否隐藏
  var _isHide = false;

  /// 透明度
  var _opacity = 1.0;

  /// 动画控制器
  AnimationController? _animationController;

  /// 位置
  late Offset _position = widget.options.position ?? Offset.zero;

  /// 计时器
  Timer? _timer;

  /// 高
  double get height => widget.options.height ?? _kDefaultSize;

  /// 是否拖动
  bool get isDragging => _isDragging;

  /// 是否隐藏
  bool get isHide => _isHide;

  /// 设置是否隐藏
  set isHide(bool value) {
    if (_isHide != value) {
      _isHide = value;
      _opacity = value ? widget.options.opacity ?? 0.15 : 1.0;
      if (widget.options.isAdsorb) {
        _isAnimated = true;
        final offset = Offset(width / 2, 0);
        if ((_position.dx == 0 && value) || (_position.dx == screenWidth - (width / 2) && !value)) {
          _position -= offset;
        } else {
          _position += offset;
        }
      }
    }
  }

  /// 屏幕高
  double get screenHeight => screenSize.height;

  /// 屏幕大小
  Size get screenSize {
    if (mounted) {
      return MediaQuery.sizeOf(context);
    }
    return Size.zero;
  }

  /// 屏幕宽
  double get screenWidth => screenSize.width;

  /// 宽
  double get width => widget.options.width ?? _kDefaultSize;

  /// 吸附定位
  void adsorbPositioned() {
    if (mounted) {
      final screenSize = MediaQuery.sizeOf(context);
      // 如果拖动结束后，位置超出了屏幕，就将位置放到屏幕边缘
      final dy = _position.dy.clamp(0, screenSize.height - height).toDouble();
      var dx = _position.dx.clamp(0, screenSize.width - width).toDouble();
      if (widget.options.isAdsorb) {
        _isAnimated = true;
        dx = dx > (screenSize.width - width) / 2 ? screenSize.width - width : 0;
      }

      final newPosition = Offset(dx, dy);
      if (newPosition == _position) {
        _autoHide();
      } else {
        _position = newPosition;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) {
      var child = _buildContent(false);

      child = Draggable(
        onDragStarted: () {
          _isDragging = true;
          _cancelTimer();
          setState(() {
            isHide = false;
            _isAnimated = false;
          });
        },
        onDragUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        onDragEnd: (details) {
          debugPrint('onDragEnd ${DateTime.now()}');
          _isDragging = false;
          setState(adsorbPositioned);
        },
        onDragCompleted: () {
          debugPrint('onDragCompleted');
        },
        onDraggableCanceled: (velocity, offset) {},
        feedback: _buildContent(true),
        childWhenDragging: const SizedBox.shrink(),
        child: child,
      );
      child = AnimatedPositioned(
        left: _position.dx,
        top: _position.dy,
        duration: _isAnimated ? const Duration(milliseconds: 300) : Duration.zero,
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 300),
          child: child,
        ),
        onEnd: () {
          _isAnimated = false;
          _autoHide();
        },
      );

      return child;
    }
    return const SizedBox.shrink();
  }

  Widget _buildContent(bool feedback) {
    return RawGestureDetector(
      gestures: {
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(
            duration: const Duration(seconds: 5),
          ),
          (instance) => instance.onLongPress = widget.options.onLongPressed,
        ),
        TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          TapGestureRecognizer.new,
          (instance) => instance.onTap = feedback
              ? null
              : () {
                  _autoHide();
                  if (isHide) {
                    setState(() {
                      isHide = false;
                    });
                  } else {
                    widget.options.onPressed?.call();
                  }
                },
        ),
      },
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: feedback
              ? widget.options.dragColor ?? Colors.yellow
              : widget.options.color ?? Colors.green,
        ),
        child: Icon(widget.options.icon ?? Icons.build),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _animationController ??= AnimationController(
      vsync: this, // ✅ 这里安全获取 vsync
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!kReleaseMode) {
      isHide = false;
      _isAnimated = false;
      // 重新计算位置
      adsorbPositioned();
    }
  }

  @override
  void dispose() {
    if (!kReleaseMode && mounted) {
      _cancelTimer();
      _animationController?.dispose();

      WidgetsBinding.instance.removeObserver(this);
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.options.showEntry) {
      if (widget.options.isHiding) {
        _resetTimer();
      }

      WidgetsFlutterBinding.ensureInitialized();

      final screenHeight =
          WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height /
              WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

      setState(() {
        _position = widget.options.position ?? Offset(0, (screenHeight - height) / 2.0);
      });
      WidgetsBinding.instance.addObserver(this);
    }
  }

  /// 取消计时器
  void _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// 自动隐藏
  void _autoHide() {
    // 条件：需要开启自动隐藏 &&不是隐藏中 && 不是拖动中
    if (widget.options.isHiding && !isHide && !isDragging) {
      _resetTimer();
    }
  }

  /// 重置计时器
  void _resetTimer() {
    // 取消之前的计时器（如果有）
    _cancelTimer();
    // 创建一个新的计时器，3秒后将值设为false
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        isHide = true;
      });
    });
  }
}
