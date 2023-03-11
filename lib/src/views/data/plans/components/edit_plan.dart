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
      actionsAlignment: MainAxisAlignment.center,
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
      actions: <Widget>[
        ElevatedButton.icon(
          onPressed: onCancel,
          icon: const Icon(Icons.cancel),
          label: Text(Language.instance.Cancel),
        ),
        ElevatedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
          label: Text(Language.instance.Edit_Plan),
          style: Themes.instance.AddButtonStyle,
        ),
      ],
    );
  }
}
