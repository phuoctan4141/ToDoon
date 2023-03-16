import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

class EditPlan extends StatelessWidget {
  final TextEditingController controller;

  final VoidCallback onEdit;
  final VoidCallback onCancel;

  // ignore: prefer_const_constructors_in_immutables
  EditPlan({
    Key? key,
    required this.controller,
    required this.onEdit,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Edit_Plan),
      content: TextField(
        minLines: 1,
        maxLength: 128,
        controller: controller,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          label: Text(Language.instance.Name_Plan),
          hintText: Language.instance.New_Plan,
          border: const OutlineInputBorder(),
        ),
      ),
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
            onPressed: onCancel,
            icon: const Icon(Icons.cancel),
            label: Text(Language.instance.Cancel),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: Text(Language.instance.OK),
            style: Themes.instance.AddButtonStyle,
          ),
        ),
      ],
    );
  }
}
