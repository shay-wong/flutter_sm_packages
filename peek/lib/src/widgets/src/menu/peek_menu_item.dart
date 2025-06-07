import 'package:flutter/material.dart';

/// 菜单项
enum MenuItemType {
  /// 未知
  unknown,

  /// 关闭
  close,

  /// 检查
  inspector,
}

/// 菜单项
class PeekMenuItem extends StatelessWidget {
  // ignore: public_member_api_docs
  const PeekMenuItem({
    required this.icon,
    required this.color,
    required this.dimension,
    this.onPressed,
    this.tooltip,
    super.key,
  });

  /// 颜色
  final Color color;

  /// 尺寸
  final double dimension;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 图标
  final Widget icon;

  /// 提示
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      style: IconButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        fixedSize: Size.square(dimension * 2 / 3),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      tooltip: tooltip,
    );
  }
}
