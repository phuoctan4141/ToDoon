// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

class AddPLan extends StatelessWidget {
  final TextEditingController controller;

  final VoidCallback onAdd;
  final VoidCallback onCancel;

  // ignore: prefer_const_constructors_in_immutables
  AddPLan({
    Key? key,
    required this.controller,
    required this.onAdd,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Add_Plan),
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
          onPressed: onAdd,
          icon: const Icon(Icons.format_list_bulleted_add),
          label: Text(Language.instance.Add_Plan),
          style: Themes.instance.AddButtonStyle,
        ),
      ],
    );
  }
}
