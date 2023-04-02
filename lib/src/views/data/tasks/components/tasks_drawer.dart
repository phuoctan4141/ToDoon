// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/routes/routes.dart';
import 'package:todoon/src/views/data/tasks/pages/task_edit_page.dart';

class TasksDrawer extends StatelessWidget {
  Plan plan;
  List<Task> tasks;
  Task task;
  ScrollController scrollController;

  TasksDrawer({
    Key? key,
    required this.plan,
    required this.tasks,
    required this.task,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading:
              Icon(ToDoonIcons.task, color: Themes.instance.RadioSelectedColor),
          title: Text(Language.instance.Tasks,
              // ignore: prefer_const_constructors
              style: Themes.instance.DrawerTitleContentTextStyle),
        ),
        const Divider(),
        _TaskskList(context, tasks),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget _TaskskList(BuildContext context, List<Task> tasks) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shrinkWrap: true,
        controller: scrollController,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
                backgroundColor: Themes.instance
                    .DrawerItemCompleteContentColor(tasks[index].complete),
                child: Text(plan.name[0])),
            // ignore: prefer_const_constructors
            title: Text(tasks[index].description,
                style: Themes.instance
                    .DrawerItemContentTextStyle(tasks[index].complete)),
            onTap: () {
              if (tasks[index].id != task.id) {
                Navigator.popAndPushNamed(
                  context,
                  TaskEditPage.routeName,
                  arguments: TaskPageArguments(plan, tasks[index]),
                );
              }
            },
          );
        });
  }
}
