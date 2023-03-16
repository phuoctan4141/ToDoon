// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors_in_immutables, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

class AlertNoticeTask extends StatelessWidget {
  Widget? content;
  final VoidCallback onNotice;
  final VoidCallback onCancel;

  AlertNoticeTask({
    Key? key,
    this.content,
    required this.onNotice,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Alert),
      content: content,
      actionsPadding:
          const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.end,
      actions: [
        // Cancel alert task.
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel),
            label: Text(Language.instance.Cancel),
          ),
        ),
        // Accept alert task.
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: onNotice,
            icon: const Icon(Icons.edit_note),
            label: Text(Language.instance.OK),
            style: Themes.instance.AddButtonStyle,
          ),
        ),
      ],
    );
  }
}
