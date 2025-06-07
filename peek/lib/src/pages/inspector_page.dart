import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../peek.dart';
import '../widgets/src/peek_scaffold.dart';

/// 调试页面
class InspectorPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const InspectorPage({
    super.key,
  });

  @override
  State<InspectorPage> createState() => _InspectorPageState();
}

class _InspectorPageState extends State<InspectorPage> {
  List<
      (
        IconData icon,
        String title,
        bool Function(),
        void Function(bool),
      )> get _listTiles => [
        (
          WidgetsApp.debugAllowBannerOverride
              ? Icons.bookmark_added_rounded
              : Icons.bookmark_remove_rounded,
          '是否允许横幅覆盖',
          () => WidgetsApp.debugAllowBannerOverride,
          _debugAllowBanner,
        ),
        (
          Icons.touch_app_rounded,
          '显示小部件检查器',
          () => WidgetsBinding.instance.debugShowWidgetInspectorOverride,
          _debugShowWidgetInspector,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PeekScaffold(
      titleText: 'Inspector',
      body: ListView.builder(
        itemBuilder: (context, index) {
          final (icon, title, value, changed) = _listTiles[index];
          return ListTile(
            leading: Icon(icon),
            title: Text(title),
            trailing: CupertinoSwitch(
              value: value(),
              onChanged: changed,
            ),
            onTap: () {
              changed(!value());
            },
          );
        },
        itemCount: _listTiles.length,
      ),
    );
  }

  void _debugShowWidgetInspector(bool value) {
    setState(() {
      WidgetsBinding.instance.debugShowWidgetInspectorOverride = value;
    });
    if (value) {
      Peek.toggleHome();
    }
  }

  void _debugAllowBanner(bool value) {
    WidgetsApp.debugAllowBannerOverride = value;
    // 重新组装应用程序
    WidgetsBinding.instance.reassembleApplication();
    // 保存偏好，用于下次启动设置
    PeekPreference.instance.inspector.setDebugAllowBannerOverride(value);
  }
}
