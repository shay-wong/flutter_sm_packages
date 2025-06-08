import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 调试器弹窗
class PeekAlert extends StatefulWidget {
  // ignore: public_member_api_docs
  const PeekAlert({
    super.key,
    this.title,
    this.confirm,
    this.cancel,
    this.onConfirm,
    this.onCancel,
    this.onDismiss,
    this.barrierDismissible = true,
  });

  /// 标题
  final String? title;

  /// 确认
  final String? confirm;

  /// 取消
  final String? cancel;

  /// 是否允许点击空白处关闭
  final bool barrierDismissible;

  /// 确认回调
  final ValueSetter<AnimationController?>? onConfirm;

  /// 取消回调
  final ValueSetter<AnimationController?>? onCancel;

  /// 关闭回调
  final ValueSetter<AnimationController?>? onDismiss;

  @override
  State<PeekAlert> createState() => _PeekAlertState();
}

class _PeekAlertState extends State<PeekAlert> {
  late AnimationController? _controller;

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      alignment: Alignment.center,
      color: Colors.black54,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ).copyWith(bottom: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (widget.title != null)
              const SizedBox(
                height: 20,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 20,
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      widget.onCancel?.call(_controller);
                    },
                    child: Text(widget.cancel ?? '取消'),
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: widget.onConfirm == null
                          ? null
                          : StadiumBorder(
                              side: BorderSide(color: Theme.of(context).colorScheme.primary),
                            ),
                    ),
                    onPressed: () {
                      widget.onConfirm?.call(_controller);
                    },
                    child: Text(widget.confirm ?? '确定'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().scale(duration: 100.ms),
    );
    if (widget.barrierDismissible) {
      child = GestureDetector(
        onTap: () {
          widget.onDismiss?.call(_controller);
        },
        child: child,
      );
    }
    return Material(
      type: MaterialType.transparency,
      child: child,
    ).animate(
      onInit: (controller) {
        _controller = controller;
      },
    ).fade(duration: 250.ms);
  }
}
