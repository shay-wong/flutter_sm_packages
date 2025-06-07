import 'package:flutter/material.dart';

/// 选项单元类型
enum PeekTileType {
  /// 网格
  grid,

  /// 列表
  list
}

/// 选项单元
abstract class PeekTile extends StatelessWidget {
  // ignore: public_member_api_docs
  const PeekTile({
    super.key,
    this.icon,
    this.title,
    this.onTap,
  });

  /// 图标
  final Widget? icon;

  /// 标题
  final Widget? title;

  /// 点击
  final VoidCallback? onTap;

  /// 类型
  PeekTileType get type;
}
