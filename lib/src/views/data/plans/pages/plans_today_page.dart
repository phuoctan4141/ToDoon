// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';

import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/routes/routes.dart';
import 'package:todoon/src/views/data/tasks/pages/task_edit_page.dart';
import 'package:todoon/src/views/widgets/back_button_widget.dart';
import 'package:todoon/src/views/widgets/datetime_locate_widget.dart';

class PlansTodayPage extends StatefulWidget {
  static const routeName = PAGE_PLANS_TODAY;
  const PlansTodayPage({super.key});

  @override
  State<PlansTodayPage> createState() => _PlansTodayPageState();
}

class _PlansTodayPageState extends State<PlansTodayPage> {
  late List<Plan> plans;
  late List<PlanPanel> planPanels = [];

  @override
  void initState() {
    super.initState();
    plans = context.read<DataController>().getDataToday.plans;
    if (plans.isNotEmpty) {
      for (var plan in plans) {
        planPanels.add(PlanPanel(plan: plan));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: prefer_const_literals_to_create_immutables
      appBar: AppBar(
        // ignore: prefer_const_constructors
        leading: BackButtonWidget(),
        title: Text(Language.instance.Focus_Content,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
          child: Container(
        child: _buildPanel(context),
      )),
    );
  }

  // ExpansionPanelList.
  _buildPanel(BuildContext context) {
    // ignore: prefer_const_constructors
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          planPanels[index].isExpanded = !isExpanded;
        });
      },
      // ignore: prefer_const_literals_to_create_immutables
      children: planPanels.map<ExpansionPanel>(
        (PlanPanel planPanel) {
          return ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(
                leading: CircleAvatar(child: Text(planPanel.plan.name[0])),
                title: Text(planPanel.plan.name),
              );
            },
            body: _buildTasksList(
              context,
              planPanel.plan,
            ),
            isExpanded: planPanel.isExpanded,
          );
        },
      ).toList(),
    );
  }

  // ExpansionPanel.
  _buildTasksList(BuildContext context, Plan plan) {
    final tasksList = TasksList(
        tasks: context.read<DataController>().getTasksToday(plan.tasks));

    return ListView.builder(
      clipBehavior: Clip.antiAlias,
      shrinkWrap: true,
      itemCount: tasksList.tasks.length,
      itemBuilder: (context, indexTask) =>
          _buildTaskTile(context, plan, tasksList.tasks, indexTask),
    );
  }

  // ExpansionPanel.
  _buildTaskTile(
      BuildContext context, Plan plan, List<Task> tasks, int indexTask) {
    final task = tasks[indexTask];

    return ListTile(
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
      onTap: () => _routeTask(context, plan, task),
    );
  }

  _routeTask(BuildContext context, Plan plan, Task task) {
    Navigator.pushNamed(context, TaskEditPage.routeName,
        arguments: TaskPageArguments(plan, task));
  }
}

class PlanPanel {
  Plan plan;
  late bool isExpanded;

  PlanPanel({
    required this.plan,
    this.isExpanded = false,
  });
}
