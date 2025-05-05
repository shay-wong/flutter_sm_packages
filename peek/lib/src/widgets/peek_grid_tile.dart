import 'peek_tile.dart';

/// 自定义选项
class PeekGridTile extends PeekTile {
  // ignore: public_member_api_docs
  const PeekGridTile({super.footer, super.child, super.onTap});

  @override
  PeekTileType get type => PeekTileType.grid;
}
