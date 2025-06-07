import 'package:flutter/widgets.dart';

/// 入口选项
class EntryOptions {
  // ignore: public_member_api_docs
  const EntryOptions({
    this.color,
    this.dragColor,
    this.dimension,
    this.hideDuration = const Duration(seconds: 3),
    this.icon,
    this.adsorb = true,
    this.autoHide = true,
    this.fold = true,
    this.longPressDuration = const Duration(seconds: 1),
    this.onLongPressed,
    this.onPressed,
    this.opacity,
    this.position,
    this.showEntry = true,
  });

  /// 是否吸附
  final bool adsorb;

  /// 是否自动隐藏
  final bool autoHide;

  /// 入口的颜色
  final Color? color;

  /// 入口的大小
  final double? dimension;

  /// 入口的拖拽颜色
  final Color? dragColor;

  /// 是否收起
  final bool fold;

  /// 自动隐藏时间
  final Duration hideDuration;

  /// 自定义图标
  final IconData? icon;

  /// 长按触发时间
  final Duration longPressDuration;

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

  /// 拷贝
  EntryOptions copyWith({
    Color? color,
    Color? dragColor,
    Duration? hideDuration,
    IconData? icon,
    bool? adsorb,
    bool? autoHide,
    bool? fold,
    VoidCallback? onLongPressed,
    VoidCallback? onPressed,
    double? opacity,
    Offset? position,
    bool? showEntry,
    double? dimension,
  }) {
    return EntryOptions(
      color: color ?? this.color,
      dragColor: dragColor ?? this.dragColor,
      hideDuration: hideDuration ?? this.hideDuration,
      icon: icon ?? this.icon,
      adsorb: adsorb ?? this.adsorb,
      autoHide: autoHide ?? this.autoHide,
      fold: fold ?? this.fold,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      onPressed: onPressed ?? this.onPressed,
      opacity: opacity ?? this.opacity,
      position: position ?? this.position,
      showEntry: showEntry ?? this.showEntry,
      dimension: dimension ?? this.dimension,
    );
  }

  /// 拷贝
  EntryOptions merge({
    Color? color,
    Color? dragColor,
    IconData? icon,
    VoidCallback? onLongPressed,
    VoidCallback? onPressed,
    double? opacity,
    Offset? position,
    bool? showEntry,
    double? dimension,
    double? height,
  }) {
    return copyWith(
      color: this.color ?? color,
      dragColor: this.dragColor ?? dragColor,
      icon: this.icon ?? icon,
      onLongPressed: this.onLongPressed ?? onLongPressed,
      onPressed: this.onPressed ?? onPressed,
      opacity: this.opacity ?? opacity,
      position: this.position ?? position,
      dimension: this.dimension ?? dimension,
    );
  }
}
