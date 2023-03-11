// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  String title = '';
  TextStyle? titleStyle;
  List<Widget> children;

  SettingsSection({
    Key? key,
    required this.title,
    this.titleStyle,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: titleStyle,
        ),
        subtitle: Column(
          children: children,
        ),
      ),
    );
  }
}
