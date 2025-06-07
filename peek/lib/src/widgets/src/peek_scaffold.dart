import 'package:flutter/material.dart';

import '../../../peek.dart';

/// [PeekScaffold]
class PeekScaffold extends Scaffold {
  // ignore: public_member_api_docs
  PeekScaffold({
    super.key,
    Widget? title,
    String? titleText,
    super.body,
  }) : super(
          appBar: AppBar(
            title: title ?? (titleText != null ? Text(titleText) : null),
            actions: const [
              CloseButton(
                onPressed: Peek.toggleHome,
              ),
            ],
          ),
        );
}
