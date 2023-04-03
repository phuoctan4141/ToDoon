// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, non_constant_identifier_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

/// DateTime Locate Task Widget.
/// This widget is used to display the date and time of the task.
/// The date and time are displayed according to the current location.
/// The date and time are displayed in the format of the current location.
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
        /// Due Date Task.
        Row(
          children: [
            Icon(
              ToDoonIcons.dueDate,
              color: Themes.instance.TaskItemCompleteColor(complete),
            ),
            Text(
              DateTimetoString(dateString),
              style: TextStyle(
                  color: Themes.instance.TaskItemCompleteColor(complete)),
            ),
          ],
        ),

        /// Reminder Task.
        Row(
          children: [
            Icon(ToDoonIcons.reminder,
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

  /// Convert date and time to string.
  /// @param [String] formattedString.
  /// @return [String] object.
  String DateTimetoString(String? formattedString) {
    return DataController.instance.Iso8601toString(formattedString);
  }
}
