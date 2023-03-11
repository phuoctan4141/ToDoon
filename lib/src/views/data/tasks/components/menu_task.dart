// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';

// ignore: camel_case_types, constant_identifier_names
enum onFunc { Edit, Delete }

class MenuTask extends StatelessWidget {
  VoidCallback onEdit;
  VoidCallback onDelete;

  MenuTask({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
