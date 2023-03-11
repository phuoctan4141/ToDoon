// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/data/plans/components/edit_plan.dart';
import 'package:todoon/src/views/data/tasks/components/add_task.dart';
import 'package:todoon/src/views/data/tasks/components/menu_task.dart';
import 'package:todoon/src/views/data/tasks/components/plans_drawer.dart';
import 'package:todoon/src/views/data/tasks/components/task_title.dart';
import 'package:todoon/src/views/data/tasks/task_edit_page.dart';
import 'package:todoon/src/views/widgets/back_button_widget.dart';
import 'package:todoon/src/views/widgets/complete_count_tasks.dart';
import 'package:todoon/src/views/widgets/drawer_widget.dart';
import 'package:todoon/src/views/widgets/empty_icon_widget.dart';
import 'package:todoon/src/views/widgets/settings_button_widget.dart';
import 'package:todoon/src/views/widgets/wrong_widget.dart';

class TasksPage extends StatefulWidget {
  final Plan plan;

  // ignore: prefer_const_constructors_in_immutables
  TasksPage({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late ScrollController scrollController;
  // Content of the task controller.
  late TextEditingController textEditingDecription;
  late TextEditingController textEditingDate;
  late TextEditingController textEditingReminder;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    textEditingDecription = TextEditingController();
    textEditingDate = TextEditingController();
    textEditingReminder = TextEditingController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingDecription.dispose();
    textEditingDate.dispose();
    textEditingReminder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataController = context.read<DataController>();
    final taskList = dataController.dataModel.getTasksList(widget.plan);

    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          leading: BackButtonWidget(),
          title: Text(widget.plan.name.toString()),
          // ignore: prefer_const_literals_to_create_immutables
          actions: [
            _EditPlan(context, widget.plan),
            // ignore: prefer_const_constructors
            SettingsButtonWidget(),
          ],
        ),
        drawer: DrawerWidget(content: _buildDrawer(context)),
        body: Column(children: <Widget>[
          Expanded(child: _buildTasksList(context, taskList)),
          SafeArea(child: _completeCountTask(context, taskList))
        ]),
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  /////////////////////////////
  // View Widgets  ////////////
  // View Widgets /////////////
  /////////////////////////////

  _buildDrawer(BuildContext context) {
    final plans = context.read<DataController>().dataModel.getAllPlan;
    // ignore: avoid_unnecessary_containers
    return PlansDrawer(
        plans: plans, plan: widget.plan, scrollController: scrollController);
  }

  Widget _completeCountTask(BuildContext context, TasksList tasksList) {
    return CompleteCountTasks(tasksList: tasksList);
  }

  Widget _buildTasksList(BuildContext context, TasksList taskList) {
    final tasks = taskList.tasks;

    return tasks.isEmpty
        // ignore: prefer_const_constructors
        ? Center(child: EmptyIconWidget())
        : ListView.builder(
            clipBehavior: Clip.antiAlias,
            controller: scrollController,
            itemCount: tasks.length,
            itemBuilder: (context, indexTask) =>
                _buildTaskTile(context, tasks, indexTask),
          );
  }

  Widget _buildTaskTile(BuildContext context, List<Task> tasks, int indexTask) {
    final task = tasks[indexTask];

    return TaskTitle(
      task: task,
      onDismissed: (_) async => dismissTask(context, task),
      onChanged: (p0) async {
        final dataController = context.read<DataController>();
        task.complete = p0 ?? false;
        dataController.dataModel.updateTask(widget.plan, task);
        await dataController.writeData().then((value) => setState(() {}));
      },
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: prefer_const_constructors
          builder: (context) => TaskEditPage(
            plan: widget.plan,
            task: task,
          ),
        ),
      ).then((value) => setState(() {})),
      trailing: _menuTask(context, task),
    );
  }

  Widget _menuTask(BuildContext context, Task task) {
    return MenuTask(
        onEdit: () => Navigator.push(
              context,
              MaterialPageRoute(
                // ignore: prefer_const_constructors
                builder: (context) => TaskEditPage(
                  plan: widget.plan,
                  task: task,
                ),
              ),
            ).then((value) => setState(() {})),
        onDelete: () => deleteTask(context, task));
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async => await addNewTask(context),
      tooltip: Language.instance.Add_Task,
      child: const Icon(Icons.add_task),
    );
  }

  // ignore: non_constant_identifier_names
  _EditPlan(BuildContext context, Plan plan) {
    return IconButton(
        tooltip: Language.instance.Edit_Plan,
        onPressed: () => editPlan(context, plan),
        icon: const Icon(Icons.edit));
  }

  // ignore: unused_element
  Widget _confirmDelete(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Delete_Task),
      content: Text(Language.instance.Delete_Sure),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton.icon(
            style: Themes.instance.DismissButtonStyle,
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete),
            label: Text(Language.instance.Delete_Task)),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.cancel),
          label: Text(Language.instance.Cancel),
        ),
      ],
    );
  }

  /////////////////////////////
  // View handle  /////////////
  // View handle //////////////
  /////////////////////////////

  Future<void> editPlan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();
    final planController = TextEditingController();
    planController.text = plan.name;

    await showDialog(
      context: context,
      builder: (BuildContext context) => EditPlan(
          controller: planController,
          onEdit: () async {
            final name = planController.text;
            if (name.isEmpty) {
              Navigator.of(context).pop(false);
              wrongWidget(context);
            } else {
              plan.name = name;
              dataController.dataModel.updatePlan(plan);
              Navigator.of(context).pop(true);
              await dataController.writeData().then((value) => setState(() {
                    planController.dispose();
                  }));
            }
          },
          onCancel: () => Navigator.of(context).pop(false)),
    );
  }

  Future<void> addNewTask(BuildContext context) async {
    final dataController = context.read<DataController>();

    textEditingDecription = TextEditingController();
    textEditingDate = TextEditingController();
    textEditingReminder = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) => AddTask(
        textEditingDecription: textEditingDecription,
        textEditingDate: textEditingDate,
        textEditingReminder: textEditingReminder,
        onAdd: () async {
          final decription = textEditingDecription.text;
          final date = dataController.StringtoIso8601(textEditingDate.text);
          final reminder =
              dataController.StringtoIso8601(textEditingReminder.text);

          if (decription.isNotEmpty && date.isNotEmpty) {
            Navigator.of(context).pop(true);
            dataController.dataModel.createTask(widget.plan,
                description: decription, date: date, reminder: reminder);

            await dataController.writeData().then((value) => setState(() {}));
          } else {
            Navigator.of(context).pop(false);
            wrongWidget(context);
          }
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  Future<void> dismissTask(BuildContext context, Task task) async {
    final dataController = context.read<DataController>();
    dataController.dataModel.deleteTask(widget.plan, task);

    await dataController.writeData().then(
          (value) => setState(() {
            // showSnackBar.
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                '${task.description} ${Language.instance.Task_Dismissed}',
                overflow: TextOverflow.ellipsis,
              ),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              duration: const Duration(seconds: 1),
            ));
          }),
        );
  }

  Future<void> deleteTask(BuildContext context, Task task) async {
    final dataController = context.read<DataController>();

    final isConfirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) => _confirmDelete(context));

    if (isConfirmDelete) {
      dataController.dataModel.deleteTask(widget.plan, task);

      await dataController.writeData().then(
            (value) => setState(() {
              // showSnackBar.
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  '${Language.instance.Delete_Task} ${task.description}',
                  overflow: TextOverflow.ellipsis,
                ),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
                duration: const Duration(seconds: 1),
              ));
            }),
          );
    }
  }
}
