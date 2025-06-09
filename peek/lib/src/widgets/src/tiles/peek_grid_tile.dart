import 'package:flutter/material.dart';

import 'peek_tile.dart';

/// 自定义选项
class PeekGridTile extends PeekTile {
  // ignore: public_member_api_docs
  const PeekGridTile({
    super.key,
    super.icon,
    super.title,
    super.onTap,
  });

  @override
  PeekTileType get type => PeekTileType.grid;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!(context) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (title != null) const SizedBox(height: 10),
          if (title != null) title!,
        ],
      ),
    );
  }
}
