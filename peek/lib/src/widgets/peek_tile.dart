import 'package:flutter/widgets.dart';

/// 选项单元类型
enum PeekTileType {
  /// 网格
  grid,

  /// 列表
  list
}

/// 选项单元
abstract class PeekTile {
  // ignore: public_member_api_docs
  const PeekTile({this.footer, this.child, this.onTap});

  /// 图标
  final Widget? child;

  /// 标题
  final Widget? footer;

  /// 点击
  final VoidCallback? onTap;

  /// 类型
  PeekTileType get type;
}
