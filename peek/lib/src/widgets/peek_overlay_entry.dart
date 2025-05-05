import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 调试器覆盖层入口
class PeekOverlayEntry extends OverlayEntry {
  // ignore: public_member_api_docs
  PeekOverlayEntry({
    required super.builder,
  });

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });
    } else {
      super.markNeedsBuild();
    }
  }
}
