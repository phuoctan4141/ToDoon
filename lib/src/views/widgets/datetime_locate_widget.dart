// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, non_constant_identifier_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

class DateTimeLocateWidget extends StatelessWidget {
  String dateString;
  String reminderString;
  bool complete;

  DateTimeLocateWidget({
    Key? key,
    required this.dateString,
    required this.reminderString,
    required this.complete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.event_available_outlined,
              color: Themes.instance.TaskItemCompleteColor(complete),
            ),
            Text(
              DateTimetoString(dateString),
              style: TextStyle(
                  color: Themes.instance.TaskItemCompleteColor(complete)),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.alarm,
                color: Themes.instance.TaskItemCompleteColor(complete)),
            Text(
              DateTimetoString(reminderString),
              style: TextStyle(
                  color: Themes.instance.TaskItemCompleteColor(complete)),
            ),
          ],
        ),
      ],
    );
  }

  // format datetime by current location
  String DateTimetoString(String? formattedString) {
    return DataController.instance.Iso8601toString(formattedString);
  }
}
