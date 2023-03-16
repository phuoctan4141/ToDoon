// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/data/plans/plans_page.dart';
import 'package:todoon/src/views/data/tasks/task_edit_page.dart';
import 'package:todoon/src/views/data/tasks/tasks_page.dart';
import 'package:todoon/src/views/settings/settings_page.dart';

const String PAGE_HOME = '/';
const String PAGE_PLAN = '/plan';
const String PAGE_TASK = '/task';
const String PAGE_SETTINGS = '/settings';

Map<String, WidgetBuilder> materialRoutes = {
  PAGE_HOME: (context) => const PlansPage(),
  PAGE_SETTINGS: (context) => const SettingsPage(),
  PAGE_PLAN: (context) =>
      TasksPage(plan: ModalRoute.of(context)!.settings.arguments as Plan),
  PAGE_TASK: (context) {
    final TaskPageArguments args =
        ModalRoute.of(context)!.settings.arguments as TaskPageArguments;
    return TaskEditPage(plan: args.plan, task: args.task);
  },
};

class TaskPageArguments {
  final Plan plan;
  final Task task;

  TaskPageArguments(
    this.plan,
    this.task,
  );
}
