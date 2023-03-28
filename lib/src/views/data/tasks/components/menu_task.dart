// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

// ignore: camel_case_types, constant_identifier_names
enum onFunc { Edit, Delete }

class MenuTask extends StatelessWidget {
  Widget? icon;
  bool complete;
  bool alert;
  VoidCallback onAlert;
  VoidCallback onEdit;
  VoidCallback onDelete;

  MenuTask({
    Key? key,
    this.icon,
    required this.complete,
    required this.alert,
    required this.onAlert,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 2.0,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        _buildInkAlert(context),
        _buildPopupMenuButton(context),
      ],
    );
  }

  _buildInkAlert(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: Themes.instance.AlertCompleteBolderColor(alert),
        shape: RoundedRectangleBorder(
            borderRadius: Themes.instance.switchRollBorder),
      ),
      child: IconButton(
          onPressed: onAlert,
          tooltip: Language.instance.Reminder,
          color: Themes.instance.AlertCompleteColor(alert),
          icon: alert
              ? const Icon(Icons.alarm_on_sharp)
              : const Icon(Icons.alarm_off_sharp)),
    );
  }

  _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      icon: icon ??
          Icon(Icons.more_vert,
              color: Themes.instance.TaskItemCompleteColor(complete)),
      tooltip: Language.instance.Show_Menu,
      itemBuilder: (context) => <PopupMenuItem>[
        PopupMenuItem(
            value: onFunc.Edit,
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: Text(Language.instance.Edit),
            )),
        PopupMenuItem(
            value: onFunc.Delete,
            child: ListTile(
              leading: const Icon(Icons.delete_forever),
              title: Text(Language.instance.Detete),
            )),
      ],
      onSelected: (value) {
        if (value == onFunc.Edit) onEdit.call();
        if (value == onFunc.Delete) onDelete.call();
      },
    );
  }
}
