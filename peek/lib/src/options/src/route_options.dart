import 'package:flutter/widgets.dart';

/// 路由选项
class RouteOptions {
  // ignore: public_member_api_docs
  const RouteOptions({
    this.getNavigatorKey,
  });

  /// 获取导航器的key
  final GlobalKey<NavigatorState>? Function()? getNavigatorKey;
}
