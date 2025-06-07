import 'package:flutter/material.dart';

import 'peek_tile.dart';

/// 自定义选项
class PeekListTile extends PeekTile {
  // ignore: public_member_api_docs
  const PeekListTile({
    super.key,
    super.icon,
    super.title,
    this.trailing,
    super.onTap,
  });

  /// 尾部
  final Widget? trailing;

  @override
  PeekTileType get type => PeekTileType.list;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      leading: icon,
      trailing: trailing ?? (onTap == null ? null : const Icon(Icons.navigate_next)),
      onTap: onTap,
    );
  }
}
