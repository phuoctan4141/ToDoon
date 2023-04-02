import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

class AlertDeletePlan extends StatelessWidget {
  const AlertDeletePlan({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Delete_Plan),
      content: Text(Language.instance.Delete_Sure),
      actionsPadding:
          const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0),
      actionsOverflowAlignment: OverflowBarAlignment.end,
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
              style: Themes.instance.DismissButtonStyle,
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(ToDoonIcons.delete),
              label: Text(Language.instance.Delete_Plan)),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(ToDoonIcons.cancel),
            label: Text(Language.instance.Cancel),
          ),
        ),
      ],
    );
  }
}
