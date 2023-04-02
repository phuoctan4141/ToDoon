// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/widgets/complete_count_tasks.dart';
import 'package:todoon/src/views/widgets/status_pie_widget.dart';

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
            leading: _buildCircleStatus(context),
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

  _buildCircleStatus(BuildContext context) {
    final datacontroller = context.watch<DataController>();
    final tasksList = datacontroller.getTasksList(plan);
    double deadLenght =
        datacontroller.getDeadlineTasksList(tasksList).tasks.length.toDouble();
    double notLenght = datacontroller
        .getNotCompleteTasksList(tasksList)
        .tasks
        .length
        .toDouble();
    double comLenght =
        datacontroller.getCompleteTasksList(tasksList).tasks.length.toDouble();

    return StatusPieWidget(
        deadLenght: deadLenght,
        notLenght: notLenght,
        comLenght: comLenght,
        centerText: plan.name[0]);
  }

  Widget _backgroundDismissible(BuildContext context) {
    return Container(
      color: Themes.instance.DismissibleBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(ToDoonIcons.delete_sweep,
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
              style: Themes.instance.DismissButtonStyle,
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(ToDoonIcons.delete),
              label: Text(Language.instance.Dismiss_Plan)),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(ToDoonIcons.cancel),
            label: Text(Language.instance.Cancel),
          ),
        ),
      ],
    );
  }

  Widget _completeCountTask(BuildContext context, tasks) {
    final tasksList = TasksList(tasks: tasks);
    return CompleteCountTasks(tasksList: tasksList);
  }
}
