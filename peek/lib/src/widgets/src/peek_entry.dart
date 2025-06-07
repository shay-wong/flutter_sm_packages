import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../peek.dart';
import '../../utils/src/logger.dart';
import '../../utils/src/prefrence/options_preference.dart';
import 'menu/peek_menu.dart';

const _kDefaultDimension = 50.0;

/// 调试器
class PeekEntry extends StatefulWidget {
  /// Constructor
  const PeekEntry({
    required this.options,
    required this.menuOptions,
    super.key,
  });

  /// 菜单
  final MenuOptions menuOptions;

  /// 选项
  final EntryOptions options;

  @override
  State<PeekEntry> createState() => PeekEntryState();
}

/// 状态
class PeekEntryState extends State<PeekEntry>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final PeekMenuController _menuController = PeekMenuController();

  /// 动画控制器
  AnimationController? _animationController;

  var _isAnimated = false;
  var _isDragging = false;
  bool _isFold = false;
  var _isHide = false;
  var _opacity = 1.0;

  /// 位置
  late Offset _position = Offset(
    _prefs.dx ?? widget.options.position?.dx ?? 0,
    _prefs.dy ?? widget.options.position?.dy ?? 0,
  );

  /// 计时器
  Timer? _timer;

  /// 是否自动吸附
  bool get adsorb => _prefs.adsorb ?? widget.options.adsorb;

  /// 是否自动隐藏
  bool get autoHide => _prefs.autoHide ?? widget.options.autoHide;

  /// 大小
  double get dimension => widget.options.dimension ?? _kDefaultDimension;

  /// 是否自动收起
  bool get fold => _prefs.fold ?? widget.options.fold;

  /// 是否拖动中
  bool get isDragging => _isDragging;

  /// 是否收起
  bool get isFlod => _isFold;

  /// 设置是否收起
  set isFlod(bool value) {
    if (_isFold != value) {
      _isFold = value;
      if (adsorb && fold) {
        _isAnimated = true;
        final xOffset = dimension / 2;
        if (_position.dx <= 0) {
          _position = Offset(value ? -xOffset : 0, _position.dy);
        } else {
          _position = Offset(
            value ? screenWidth - xOffset : screenWidth - dimension,
            _position.dy,
          );
        }
      }
    }
  }

  /// 是否隐藏
  bool get isHide => _isHide;

  /// 设置是否隐藏
  set isHide(bool value) {
    if (_isHide != value) {
      _isHide = value;
      _opacity = value ? widget.options.opacity ?? 0.15 : 1.0;
    }
  }

  /// 屏幕高
  double get screenHeight => screenSize.height;

  /// 屏幕大小
  Size get screenSize {
    if (mounted) {
      return MediaQuery.sizeOf(context);
    }
    final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
    if (view == null) {
      return Size.zero;
    }
    final screenSize = view.physicalSize / view.devicePixelRatio;
    return screenSize;
  }

  /// 屏幕宽
  double get screenWidth => screenSize.width;

  OptionsPreference get _prefs => PeekPreference.instance.options;

  /// 吸附定位
  void adsorbPositioned() {
    // 如果拖动结束后，位置超出了屏幕，就将位置放到屏幕边缘
    final dy = _position.dy.clamp(0, screenSize.height - dimension).toDouble();
    var dx = _position.dx.clamp(0, screenSize.width - dimension).toDouble();
    if (adsorb) {
      _isAnimated = true;
      dx = dx > (screenSize.width - dimension) / 2 ? screenSize.width - dimension : 0;
    }

    final newPosition = Offset(dx, dy);
    if (newPosition == _position) {
      Logger.debug('adsorbPositioned');
      _autoHide();
    } else {
      _position = newPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.showEntry) {
      var child = _buildContent(false);

      child = Draggable(
        onDragStarted: () {
          _isDragging = true;
          _cancelTimer();
          setState(() {
            isHide = false;
            isFlod = false;
            _isAnimated = false;
          });
        },
        onDragUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        onDragEnd: (details) {
          _isDragging = false;
          setState(adsorbPositioned);
        },
        onDragCompleted: () {},
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
          if (!isDragging) {
            _isAnimated = false;
            Logger.debug('onEnd');
            _autoHide();
            _prefs
              ..setDx(_position.dx.clamp(0, screenSize.width - dimension).toDouble())
              ..setDy(_position.dy);
          }
        },
      );

      return child;
    }
    return const SizedBox.shrink();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _animationController ??= AnimationController(
      vsync: this,
      duration: widget.options.hideDuration,
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (widget.options.showEntry && mounted) {
      isHide = false;
      isFlod = false;
      _isAnimated = false;
      // 重新计算位置
      adsorbPositioned();
    }
  }

  @override
  void dispose() {
    if (widget.options.showEntry && mounted) {
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
      _autoHide();

      WidgetsFlutterBinding.ensureInitialized();
      if (_position == Offset.zero) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _position = widget.options.position ??
                Offset(
                  0,
                  (screenHeight - dimension) / 2.0,
                );
          });
        });
      }
      WidgetsBinding.instance.addObserver(this);
    }
  }

  /// 隐藏
  void toggleHide() {
    setState(() {
      isHide = false;
      isFlod = false;
      _isAnimated = false;
      // 重新计算位置
      adsorbPositioned();
    });
  }

  /// 自动隐藏
  void _autoHide() {
    final isMenu = _menuController.isOpen && widget.menuOptions.autoHide;
    Logger.debug(
      '${(autoHide || isMenu || fold) && !isHide && !isDragging}, $autoHide, $isMenu, $fold, $isHide, $isDragging',
    );
    // 条件：需要开启自动隐藏 || 是菜单 || 是收起 && 不是隐藏中 && 不是拖动中
    if ((autoHide || isMenu || fold) && !isHide && !isDragging) {
      _resetTimer(
        isMenu ? widget.menuOptions.hideDuration : widget.options.hideDuration,
        () {
          isMenu
              ? _menuController.close().whenComplete(_autoHide)
              : setState(() {
                  if (autoHide) {
                    isHide = true;
                  }
                  if (fold) {
                    isFlod = true;
                  }
                });
        },
      );
    }
  }

  Widget _buildContent(bool feedback) {
    final canMenu = widget.menuOptions.enable && !feedback && (!isHide || !isFlod);
    Widget content = RawGestureDetector(
      gestures: {
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(
            duration: widget.options.longPressDuration,
          ),
          (instance) => instance
            ..onLongPressStart = (details) {
              _cancelTimer();
              setState(() {
                isHide = false;
                isFlod = false;
                _isAnimated = false;
              });
            }
            ..onLongPressEnd = (details) {
              if (widget.menuOptions.autoHide || !_menuController.isOpen) {
                _autoHide();
              }
            }
            ..onLongPress = widget.options.onLongPressed ??
                (canMenu
                    ? () {
                        if (_menuController.isOpen) {
                          _menuController.close();
                        } else {
                          _menuController.open();
                        }
                      }
                    : null),
        ),
      },
      child: SizedBox.square(
        dimension: dimension,
        child: Material(
          color: feedback
              ? widget.options.dragColor ?? Colors.yellow
              : widget.options.color ?? Colors.green,
          type: MaterialType.circle,
          clipBehavior: Clip.hardEdge,
          child: InkResponse(
            onTap: feedback
                ? null
                : () {
                    if (_menuController.isOpen) {
                      _menuController.close();
                    }
                    if (isHide || isFlod) {
                      setState(() {
                        isHide = false;
                        isFlod = false;
                      });
                    } else {
                      widget.options.onPressed?.call();
                    }
                    _autoHide();
                  },
            child: Icon(
              widget.options.icon ?? Icons.troubleshoot_rounded,
            ),
          ),
        ),
      ),
    );

    if (canMenu && widget.options.onLongPressed == null) {
      content = PeekMenu(
        options: widget.options,
        menuOptions: widget.menuOptions,
        menuController: _menuController,
        position: _position,
        child: content,
      );
    }

    return content;
  }

  /// 取消计时器
  void _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// 重置计时器
  void _resetTimer(Duration duration, void Function() callback) {
    // 取消之前的计时器（如果有）
    _cancelTimer();
    // 创建一个新的计时器
    _timer = Timer(duration, callback);
  }
}

/// 随机拓展
extension RandomExtension on Random {
  /// 随机颜色
  Color nextColor() {
    return Color.fromARGB(
      255, // 不透明
      nextInt(256),
      nextInt(256),
      nextInt(256),
    );
  }
}
