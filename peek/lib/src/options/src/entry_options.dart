import 'package:flutter/widgets.dart';

/// 入口选项
class EntryOptions {
  // ignore: public_member_api_docs
  const EntryOptions({
    this.color,
    this.dragColor,
    double? height,
    this.hideDuration = const Duration(seconds: 3),
    this.icon,
    this.isAdsorb = true,
    this.isHiding = true,
    this.onLongPressed,
    this.onPressed,
    this.opacity,
    this.position,
    this.showEntry = true,
    double? size,
    double? width,
  })  : width = width ?? size,
        height = height ?? size;

  /// 入口的颜色
  final Color? color;

  /// 入口的拖拽颜色
  final Color? dragColor;

  /// 入口的高度
  final double? height;

  /// 自动隐藏时间
  final Duration hideDuration;

  /// 自定义图标
  final IconData? icon;

  /// 是否吸附
  final bool isAdsorb;

  /// 是否自动隐藏
  final bool isHiding;

  /// 长按回调
  final VoidCallback? onLongPressed;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 入口闲置的透明度
  final double? opacity;

  /// 入口的位置
  final Offset? position;

  /// 是否显示入口
  final bool showEntry;

  /// 入口的宽度
  final double? width;

  /// 拷贝
  EntryOptions copyWith({
    Color? color,
    Color? dragColor,
    double? height,
    Duration? hideDuration,
    IconData? icon,
    bool? isAdsorb,
    bool? isHiding,
    VoidCallback? onLongPressed,
    VoidCallback? onPressed,
    double? opacity,
    Offset? position,
    bool? showEntry,
    double? width,
  }) {
    return EntryOptions(
      color: color ?? this.color,
      dragColor: dragColor ?? this.dragColor,
      height: height ?? this.height,
      hideDuration: hideDuration ?? this.hideDuration,
      icon: icon ?? this.icon,
      isAdsorb: isAdsorb ?? this.isAdsorb,
      isHiding: isHiding ?? this.isHiding,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      onPressed: onPressed ?? this.onPressed,
      opacity: opacity ?? this.opacity,
      position: position ?? this.position,
      showEntry: showEntry ?? this.showEntry,
      width: width ?? this.width,
    );
  }

  /// 拷贝
  EntryOptions merge({
    Color? color,
    Color? dragColor,
    double? height,
    IconData? icon,
    VoidCallback? onLongPressed,
    VoidCallback? onPressed,
    double? opacity,
    Offset? position,
    bool? showEntry,
    double? width,
  }) {
    return copyWith(
      color: this.color ?? color,
      dragColor: this.dragColor ?? dragColor,
      height: this.height ?? height,
      icon: this.icon ?? icon,
      onLongPressed: this.onLongPressed ?? onLongPressed,
      onPressed: this.onPressed ?? onPressed,
      opacity: this.opacity ?? opacity,
      position: this.position ?? position,
      width: this.width ?? width,
    );
  }
}
