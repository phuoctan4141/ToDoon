// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/widgets/datetime_locate_widget.dart';

class TaskTitle extends StatelessWidget {
  Task task;
  Widget? trailing;
  Function(DismissDirection)? onDismissed;
  Function(bool?)? onChanged;
  Function()? onTap;

  TaskTitle({
    Key? key,
    required this.task,
    this.trailing,
    this.onDismissed,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(task),
        direction: DismissDirection.endToStart,
        background: _backgroundDismissible(context),
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return _confirmDismiss(context);
              });
        },
        onDismissed: onDismissed,
        child: _buildTaskSection(context));
  }

  Widget _buildTaskSection(BuildContext context) {
    return Card(
      color: Themes.instance.TaskSectionCompleteColor(task.complete),
      child: ListTile(
        leading: Transform.scale(
          scale: 1.5,
          child: Checkbox(
            value: task.complete,
            onChanged: onChanged,
            activeColor: Themes.instance.RadioSelectedColor,
          ),
        ),
        title: Text(
          task.description,
          overflow: TextOverflow.ellipsis,
          style: Themes.instance.TaskDescriptionTextStyle(task.complete),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        subtitle: DateTimeLocateWidget(
            dateString: task.date,
            reminderString: task.reminder,
            complete: task.complete),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _backgroundDismissible(BuildContext context) {
    return Container(
      color: Themes.instance.DismissibleBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_sweep,
                color: Themes.instance.DismissibleBackgroundItemColor),
            Text(Language.instance.Dismiss_Task,
                style: TextStyle(
                    color: Themes.instance.DismissibleBackgroundItemColor)),
          ],
        ),
      ),
    );
  }

  Widget _confirmDismiss(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Dismiss_Task),
      content: Text(Language.instance.Dismiss_Sure),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton.icon(
            style: Themes.instance.DismissButtonStyle,
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete),
            label: Text(Language.instance.Dismiss_Task)),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.cancel),
          label: Text(Language.instance.Cancel),
        ),
      ],
    );
  }
}
