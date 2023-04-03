// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:todoon/src/routes/routes_export.dart';

const String PAGE_INTRO = '/intro';
const String PAGE_HOME = '/';
const String PAGE_PLAN = '/plan';
const String PAGE_PLANS_TODAY = '/plans_today';
const String PAGE_TASK = '/task';
const String PAGE_SETTINGS = '/settings';

Map<String, WidgetBuilder> materialRoutes = {
  // route IntroPage.dart.
  PAGE_INTRO: (context) => const IntroPage(),
  // route PlansPage.dart.
  PAGE_HOME: (context) => PlansPage(),
  // route SettingsPage.dart.
  PAGE_SETTINGS: (context) => const SettingsPage(),
  // route TasksPage.dart.
  PAGE_PLAN: (context) =>
      TasksPage(plan: ModalRoute.of(context)!.settings.arguments as Plan),
  // route PlansTodayPage.dart.
  PAGE_PLANS_TODAY: (context) => const PlansTodayPage(),
  // route TaskEditPage.dart.
  PAGE_TASK: (context) {
    final TaskPageArguments args =
        ModalRoute.of(context)!.settings.arguments as TaskPageArguments;
    return TaskEditPage(plan: args.plan, task: args.task);
  },
};

/// Arguments for [TaskEditPage].
class TaskPageArguments {
  final Plan plan;
  final Task task;

  TaskPageArguments(
    this.plan,
    this.task,
  );
}
