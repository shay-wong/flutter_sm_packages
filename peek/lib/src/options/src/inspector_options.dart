import 'package:flutter/material.dart';

/// 调试器选项
class InspectorOptions {
  // ignore: public_member_api_docs
  const InspectorOptions({
    this.showSemanticsDebuggerCallback,
  });

  /// 显示语义调试回调
  final ValueChanged<bool>? showSemanticsDebuggerCallback;
}
