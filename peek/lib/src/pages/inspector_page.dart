import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 调试页面
class InspectorPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const InspectorPage({
    super.key,
    this.onClose,
  });

  /// 关闭回调
  final VoidCallback? onClose;

  @override
  State<InspectorPage> createState() => _InspectorPageState();
}

class _InspectorPageState extends State<InspectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspector'),
        actions: [
          CloseButton(onPressed: widget.onClose),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.touch_app_rounded),
            title: const Text('显示小部件检查器'),
            trailing: CupertinoSwitch(
              value: WidgetsBinding.instance.debugShowWidgetInspectorOverride,
              onChanged: debugShowWidgetInspector,
            ),
            onTap: () {
              debugShowWidgetInspector(
                !WidgetsBinding.instance.debugShowWidgetInspectorOverride,
              );
            },
          );
        },
        itemCount: 1,
      ),
    );
  }

  void debugShowWidgetInspector(bool value) {
    setState(() {
      WidgetsBinding.instance.debugShowWidgetInspectorOverride = value;
    });
    if (value) {
      widget.onClose?.call();
    }
  }
}
