// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  String title = '';
  Widget? icon;
  TextStyle titleStyle;
  List<Widget> children;

  SettingsSection({
    Key? key,
    required this.title,
    this.icon,
    this.titleStyle = const TextStyle(fontWeight: FontWeight.bold),
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Row(
          children: [
            Container(
              child: icon,
            ),
            icon != null
                ? const SizedBox(
                    width: 8.0,
                  )
                : Container(),
            Text(
              title,
              style: titleStyle,
            ),
          ],
        ),
        subtitle: Column(
          children: children,
        ),
      ),
    );
  }
}
