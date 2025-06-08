import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../../peek.dart';
import '../utils/src/const.dart';
import '../widgets/src/peek_scaffold.dart';

/// 列表选项
class ListOptions<T> {
  // ignore: public_member_api_docs
  ListOptions({
    required this.value,
    required this.changed,
    this.icon,
    this.title,
  });

  /// 图标
  final IconData? icon;

  /// 标题
  final String? title;

  /// 值
  final T Function() value;

  /// 改变
  final ValueChanged<T> changed;
}

/// 选项
class ListOptionsBool extends ListOptions<bool> {
  // ignore: public_member_api_docs
  ListOptionsBool({
    required super.value,
    required super.changed,
    super.icon,
    super.title,
  });
}

/// 选项
class ListOptionsDouble extends ListOptions<double> {
  // ignore: public_member_api_docs
  ListOptionsDouble({
    required super.value,
    required super.changed,
    super.icon,
    super.title,
  });
}

/// 调试页面
/// https://docs.flutter.dev/tools/devtools/inspector
///
class InspectorPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const InspectorPage({
    required this.options,
    super.key,
    this.showSemanticsDebuggerCallback,
  });

  /// 选项
  final InspectorOptions options;

  /// 显示语义调试回调
  final ValueChanged<bool>? showSemanticsDebuggerCallback;

  @override
  State<InspectorPage> createState() => _InspectorPageState();
}

class _InspectorPageState extends State<InspectorPage> {
  List<ListOptions> get _listTiles => [
        ListOptionsBool(
          icon: WidgetsApp.debugAllowBannerOverride
              ? Icons.bookmark_added_outlined
              : Icons.bookmark_remove_outlined,
          title: '是否允许横幅覆盖',
          value: () => WidgetsApp.debugAllowBannerOverride,
          changed: _debugAllowBanner,
        ),
        ListOptionsBool(
          icon: const IconData(0x1F74A),
          title: '显示小部件检查器',
          value: () => WidgetsBinding.instance.debugShowWidgetInspectorOverride,
          changed: _debugShowWidgetInspector,
        ),
        ListOptionsBool(
          icon: Icons.timer_outlined,
          title: '缓慢动画',
          value: () => timeDilation > 1.0,
          changed: (value) => _timeDilation(value ? 5.0 : 1.0),
        ),
        if (timeDilation > 1.0)
          ListOptionsDouble(
            icon: Icons.timer_outlined,
            title: '动画速度\n${timeDilation.toStringAsFixed(1)}x',
            value: () => timeDilation,
            changed: _timeDilation,
          ),
        ListOptionsBool(
          icon: Icons.expand_outlined,
          title: '显示参考线',
          value: () => debugPaintSizeEnabled,
          changed: _debugPaintSizeEnabled,
        ),
        ListOptionsBool(
          icon: Icons.text_format_rounded,
          title: '显示基线',
          value: () => debugPaintBaselinesEnabled,
          changed: _debugPaintBaselinesEnabled,
        ),
        ListOptionsBool(
          icon: Icons.highlight_alt_rounded,
          title: '画布边框高亮绘制',
          value: () => debugRepaintRainbowEnabled,
          changed: _debugRepaintRainbowEnabled,
        ),
        ListOptionsBool(
          icon: Icons.image_outlined,
          title: '反转超大图像',
          value: () => debugInvertOversizedImages,
          changed: _debugInvertOversizedImages,
        ),
        ListOptionsBool(
          icon: Icons.ssid_chart_outlined,
          title: '显示性能指示器',
          value: () => WidgetsApp.showPerformanceOverlayOverride,
          changed: _showPerformanceOverlayOverride,
        ),
        ListOptionsBool(
          icon: Icons.info_outline_rounded,
          title: '语义调试器',
          value: () => Const.showSemanticsDebuggerOverride,
          changed: (value) {
            Const.showSemanticsDebuggerOverride = value;
            widget.options.showSemanticsDebuggerCallback?.call(value);
            // 重新组装应用程序
            WidgetsBinding.instance.performReassemble();
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PeekScaffold(
      titleText: 'Inspector',
      body: ListView.builder(
        itemBuilder: (context, index) {
          final options = _listTiles[index];
          final isSwitch = options is ListOptionsBool;
          return ListTile(
            leading: options.icon == null ? null : Icon(options.icon),
            title: !isSwitch
                ? Row(
                    children: [
                      Text(
                        options.title ?? '',
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: Slider(
                          min: 2,
                          max: 10,
                          divisions: 8,
                          value: timeDilation,
                          label: '${timeDilation.toStringAsFixed(1)}x',
                          onChanged: (value) {
                            (options as ListOptionsDouble).changed.call(value);
                          },
                        ),
                      ),
                    ],
                  )
                : Text(options.title ?? ''),
            trailing: !isSwitch
                ? null
                : CupertinoSwitch(
                    value: options.value(),
                    // ignore: unnecessary_lambdas
                    onChanged: (value) {
                      options.changed.call(value);
                    },
                  ),
          );
        },
        itemCount: _listTiles.length,
      ),
    );
  }

  void _timeDilation(double value) {
    setState(() {
      timeDilation = value;
    });
  }

  void _debugPaintSizeEnabled(bool value) {
    setState(() {
      debugPaintSizeEnabled = value;
    });
  }

  void _debugPaintBaselinesEnabled(bool value) {
    setState(() {
      debugPaintBaselinesEnabled = value;
    });
  }

  void _debugRepaintRainbowEnabled(bool value) {
    setState(() {
      debugRepaintRainbowEnabled = value;
    });
  }

  void _debugInvertOversizedImages(bool value) {
    setState(() {
      debugInvertOversizedImages = value;
    });
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
    // 保存偏好，用于下次启动设置
    PeekPreference.instance.inspector.setDebugAllowBannerOverride(value);
    // 重新组装应用程序
    WidgetsBinding.instance.performReassemble();
  }

  void _showPerformanceOverlayOverride(bool value) {
    WidgetsApp.showPerformanceOverlayOverride = value;
    // 重新组装应用程序
    WidgetsBinding.instance.performReassemble();
  }
}
