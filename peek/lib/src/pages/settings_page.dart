import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../peek.dart';
import '../widgets/src/peek_scaffold.dart';

/// 列表元祖
typedef SettingsListTuple = (
  String title,
  bool Function() value,
  ValueChanged<bool>? onChanged,
);

/// 设置
class SettingsPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const SettingsPage({
    required this.options,
    super.key,
    this.onEntryOptionsChanged,
  });

  /// 入口选项更改
  final VoidCallback? onEntryOptionsChanged;

  /// 选项
  final PeekOptions options;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<SettingsListTuple> get _listTiles => [
        (
          '是否吸附',
          () => PeekPreference.instance.options.adsorb ?? widget.options.entryOptions.adsorb,
          (value) {
            setState(() {
              PeekPreference.instance.options.setAdsorb(value);
              if (!value) {
                PeekPreference.instance.options.setFold(value);
              }
              widget.onEntryOptionsChanged?.call();
            });
          },
        ),
        (
          '是否自动收起',
          () => PeekPreference.instance.options.fold ?? widget.options.entryOptions.fold,
          PeekPreference.instance.options.adsorb ?? widget.options.entryOptions.adsorb
              ? (value) {
                  setState(() {
                    PeekPreference.instance.options.setFold(value);
                    widget.onEntryOptionsChanged?.call();
                  });
                }
              : null,
        ),
        (
          '是否自动隐藏',
          () => PeekPreference.instance.options.autoHide ?? widget.options.entryOptions.autoHide,
          (value) {
            setState(() {
              PeekPreference.instance.options.setAutoHide(value);
              widget.onEntryOptionsChanged?.call();
            });
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PeekScaffold(
      titleText: 'Settings',
      body: Column(
        spacing: 10,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Icon(
            Icons.troubleshoot_rounded,
            size: 80,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Peek',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 30),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final (title, value, changed) = _listTiles[index];
              return ListTile(
                title: Text(title),
                trailing: CupertinoSwitch(
                  value: value(),
                  onChanged: changed,
                ),
                onTap: changed == null ? null : () => changed(!value()),
              );
            },
            itemCount: _listTiles.length,
            shrinkWrap: true,
          ),
          FilledButton.tonal(
            onPressed: Peek.toggle,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            ),
            child: const Text('关闭入口'),
          ),
        ],
      ),
    );
  }
}
