// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/widgets/complete_count_tasks.dart';

class PlanTitle extends StatelessWidget {
  Plan plan;
  Function(DismissDirection)? onDismissed;
  Function()? onTap;
  Widget? trailing;

  PlanTitle({
    Key? key,
    required this.plan,
    required this.onDismissed,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(plan),
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
        child: Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(plan.name[0])),
            title: Text(
              plan.name,
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: _completeCountTask(context, plan.tasks),
            onTap: onTap,
            trailing: trailing,
          ),
        ));
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
            Text(Language.instance.Dismiss_Plan,
                style: TextStyle(
                    color: Themes.instance.DismissibleBackgroundItemColor)),
          ],
        ),
      ),
    );
  }

  Widget _confirmDismiss(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Dismiss_Plan),
      content: Text(Language.instance.Dismiss_Sure),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton.icon(
            style: Themes.instance.DismissButtonStyle,
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete),
            label: Text(Language.instance.Dismiss_Plan)),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.cancel),
          label: Text(Language.instance.Cancel),
        ),
      ],
    );
  }

  Widget _completeCountTask(BuildContext context, tasks) {
    final tasksList = TasksList(tasks: tasks);
    return CompleteCountTasks(tasksList: tasksList);
  }
}
