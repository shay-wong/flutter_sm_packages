import 'package:flutter/material.dart';

import '../options/src/route_options.dart';
import '../widgets/src/peek_scaffold.dart';

/// 路由页面
class RoutePage extends StatefulWidget {
  // ignore: public_member_api_docs
  const RoutePage({
    super.key,
    this.options = const RouteOptions(),
  });

  /// 路由选项
  final RouteOptions options;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  RouteInfo? route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final route = findRoute();
      if (route != null && (route.current != null)) {
        setState(() {
          this.route = route;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PeekScaffold(
      titleText: 'Route',
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      '当前页面路由树',
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 3),
                      child: const Text(
                        'Navigator存在嵌套情况，打印当前页面在每层Navigator内的路由信息',
                        style: TextStyle(color: Color(0xff999999), fontSize: 12),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buildRouteInfoWidget(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildRouteInfoWidget(BuildContext context) {
    final widgets = <Widget>[];
    var route = this.route;
    if (route == null) {
      return widgets;
    }
    do {
      if (route?.current != null) {
        var arguments = route?.current?.settings.arguments;
        final name = route?.current?.settings.name;
        var routeName = name;
        var parameters = <String, String>{};
        if (arguments is RouteSettings) {
          routeName = arguments.name;
          arguments = arguments.arguments;
        }
        if (routeName != null) {
          final uri = Uri.tryParse(routeName);
          if (uri != null) {
            parameters = uri.queryParameters;
          }
        }
        widgets.add(
          Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color(0xfff5f6f7),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: '路由名称: ',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff333333),
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: name,
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.5,
                      color: Color(0xff666666),
                    ),
                  ),
                  if (arguments != null)
                    const TextSpan(
                      text: '\n路由参数: ',
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 10,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (arguments != null)
                    TextSpan(
                      text: '$arguments',
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.5,
                        color: Color(0xff666666),
                      ),
                    ),
                  if (parameters.isNotEmpty)
                    const TextSpan(
                      text: '\n路径参数: ',
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 10,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (parameters.isNotEmpty)
                    TextSpan(
                      text: '$parameters',
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.5,
                        color: Color(0xff666666),
                      ),
                    ),
                  const TextSpan(
                    text: '\n所在Navigator: ',
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.5,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: route?.parentNavigator != null ? route?.parentNavigator.toString() : '未知',
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.5,
                      color: Color(0xff666666),
                    ),
                  ),
                  const TextSpan(
                    text: '\n所有信息: ',
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.5,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: route?.current.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.5,
                      color: Color(0xff666666),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      route = route?.parent;
      if (route != null && route.parent != null) {
        widgets.add(
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.center,
            child: Image.asset('images/dk_route_arrow.png', height: 13, width: 12),
          ),
        );
      }
      // 过滤掉dokit自带的navigator
    } while (route != null);
    return widgets;
  }

  RouteInfo? findRoute() {
    Element? topElement;
    final context = widget.options.getNavigatorKey?.call()?.currentContext;
    if (context == null) {
      return null;
    }
    final ModalRoute<dynamic>? rootRoute = ModalRoute.of(context);
    void listTopView(Element element) {
      if (element.widget is! PositionedDirectional) {
        if (element is RenderObjectElement && element.renderObject is RenderBox) {
          final ModalRoute<dynamic>? route = ModalRoute.of(element);
          if (route != null && route != rootRoute) {
            topElement = element;
          }
        }
        element.visitChildren(listTopView);
      }
    }

    context.visitChildElements(listTopView);
    if (topElement != null) {
      final routeInfo = RouteInfo()..current = ModalRoute.of(topElement!);
      buildNavigatorTree(topElement!, routeInfo);
      return routeInfo;
    }
    return null;
  }

  /// 反向遍历生成路由树
  void buildNavigatorTree(Element element, RouteInfo routeInfo) {
    final navigatorState = element.findAncestorStateOfType<NavigatorState>();

    if (navigatorState != null) {
      final parent = RouteInfo()..current = ModalRoute.of(navigatorState.context);
      routeInfo
        ..parent = parent
        ..parentNavigator = navigatorState.widget;
      return buildNavigatorTree(navigatorState.context as Element, parent);
    }
  }
}

/// 路由信息
class RouteInfo {
  /// 当前路由
  ModalRoute<dynamic>? current;

  /// 父导航器
  Widget? parentNavigator;

  /// 上级路由信息
  RouteInfo? parent;
}
