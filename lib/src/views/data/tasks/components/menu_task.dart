// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
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
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildInkAlert(context),
        _buildPopupMenuButton(context),
      ],
    );
  }

  _buildInkAlert(BuildContext context) {
    return Material(
      color: Themes.instance.AlertCompleteBolderColor(alert),
      shadowColor: Themes.instance.AlertCompleteBolderColor(alert),
      borderRadius: Themes.instance.switchRollBorder,
      child: InkWell(
        borderRadius: Themes.instance.switchRollBorder,
        onTap: onAlert,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            ToDoonIcons.getAlertState(alert),
            semanticLabel: Language.instance.Reminder,
            color: Themes.instance.AlertCompleteColor(alert),
          ),
        ),
      ),
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
              leading: const Icon(ToDoonIcons.edit),
              title: Text(Language.instance.Edit),
            )),
        PopupMenuItem(
            value: onFunc.Delete,
            child: ListTile(
              leading: const Icon(ToDoonIcons.delete),
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
