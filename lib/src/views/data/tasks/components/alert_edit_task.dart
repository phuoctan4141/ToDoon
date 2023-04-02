// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

class AlertEditTask extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  AlertEditTask({
    Key? key,
    required this.onEdit,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Edit_Task),
      content: Text(Language.instance.Edit_Sure),
      actionsPadding:
          const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.end,
      actions: [
        // Cancel edit task.
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: onCancel,
            icon: const Icon(ToDoonIcons.cancel),
            label: Text(Language.instance.Cancel),
          ),
        ),
        // Accept edit task.
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(ToDoonIcons.edit_task),
            label: Text(Language.instance.OK),
            style: Themes.instance.AddButtonStyle,
          ),
        ),
      ],
    );
  }
}
