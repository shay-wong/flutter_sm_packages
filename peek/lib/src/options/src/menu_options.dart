import 'package:flutter/widgets.dart';

/// 菜单选项
class MenuOptions {
  // ignore: public_member_api_docs
  const MenuOptions({
    this.enable = true,
    this.autoHide = true,
    this.hideDuration = const Duration(seconds: 5),
    this.items = const [],
  });

  /// 是否启用
  final bool enable;

  /// 菜单显示时是否自动隐藏入口
  final bool autoHide;

  /// 自动隐藏时间
  final Duration hideDuration;

  /// 菜单项
  final List<Widget> items;
}
