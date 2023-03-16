// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/routes/routes.dart';
import 'package:todoon/src/views/data/tasks/components/alert_detete_task.dart';
import 'package:todoon/src/views/data/tasks/components/tasks_components.dart';
import 'package:todoon/src/views/data/tasks/task_edit_page.dart';
import 'package:todoon/src/views/widgets/back_button_widget.dart';
import 'package:todoon/src/views/widgets/complete_count_tasks.dart';
import 'package:todoon/src/views/widgets/drawer_widget.dart';
import 'package:todoon/src/views/widgets/empty_icon_widget.dart';
import 'package:todoon/src/views/widgets/wrong_widget.dart';

class TasksPage extends StatefulWidget {
  static const routeName = PAGE_PLAN;
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
    return Consumer<DataController>(
      builder: (context, dataController, child) {
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
                _search(context, taskList),
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
      },
    );
  }

  /////////////////////////////
  // View Widgets  ////////////
  // View Widgets /////////////
  /////////////////////////////

  Widget _search(BuildContext context, TasksList taskList) {
    return IconButton(
        onPressed: () {
          showSearch(
              context: context,
              delegate: TaskSearchDelegate(widget.plan, taskList));
        },
        tooltip: Language.instance.Search,
        icon: const Icon(Icons.search));
  }

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
    return taskList.tasks.isEmpty
        // ignore: prefer_const_constructors
        ? Center(child: EmptyIconWidget())
        : _buildContentTaskstList(context, taskList);
  }

  _buildContentTaskstList(BuildContext context, TasksList taskList) {
    final notTasksList =
        DataController.instance.dataModel.notTasksList(taskList);
    final comTasksList =
        DataController.instance.dataModel.comTasksList(taskList);
    final deadasksList =
        DataController.instance.dataModel.deadTasksList(taskList);

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          // Deadline tasksList.
          ListView.builder(
            clipBehavior: Clip.antiAlias,
            shrinkWrap: true,
            itemCount: deadasksList.tasks.length,
            itemBuilder: (context, indexTask) =>
                _buildTaskTile(context, deadasksList.tasks, indexTask),
          ),
          // Not complete tasks.
          ListView.builder(
            clipBehavior: Clip.antiAlias,
            shrinkWrap: true,
            itemCount: notTasksList.tasks.length,
            itemBuilder: (context, indexTask) =>
                _buildTaskTile(context, notTasksList.tasks, indexTask),
          ),
          // Complete task.
          ListView.builder(
            clipBehavior: Clip.antiAlias,
            shrinkWrap: true,
            itemCount: comTasksList.tasks.length,
            itemBuilder: (context, indexTask) =>
                _buildTaskTile(context, comTasksList.tasks, indexTask),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, List<Task> tasks, int indexTask) {
    final task = tasks[indexTask];

    return TaskTitle(
      task: task,
      onDismissed: (_) async => dismissTask(context, task),
      onChanged: (p0) async {
        changeComplete(context, task, p0);
      },
      onTap: () => _routeTask(context, task),
      trailing: _menuTask(context, task),
    );
  }

  Widget _menuTask(BuildContext context, Task task) {
    return MenuTask(
      complete: task.complete,
      onEdit: () => _routeTask(context, task),
      onDelete: () => deleteTask(context, task),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async => await addNewTask(context),
      tooltip: Language.instance.Add_Task,
      child: const Icon(Icons.add_task),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _EditPlan(BuildContext context, Plan plan) {
    return IconButton(
        tooltip: Language.instance.Edit_Plan,
        onPressed: () => editPlan(context, plan),
        icon: const Icon(Icons.edit));
  }

  // ignore: unused_element
  Widget _confirmDelete(BuildContext context) {
    return const AlertDeleteTask();
  }

  /////////////////////////////
  // View handle  /////////////
  // View handle //////////////
  /////////////////////////////

  _routeTask(BuildContext context, Task task) {
    Navigator.pushNamed(context, TaskEditPage.routeName,
        arguments: TaskPageArguments(widget.plan, task));
  }

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
            final done = await dataController.editAPlan(plan, name);

            if (context.mounted) {
              if (done.compareTo(States.TRUE) == 0) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
                wrongWidget(context);
              }
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

          final done = await dataController.addNewTask(widget.plan,
              description: decription, date: date, reminder: reminder);

          if (context.mounted) {
            if (done.compareTo(States.TRUE) == 0) {
              Navigator.of(context).pop(true);
            } else {
              Navigator.of(context).pop(false);
              wrongWidget(context);
            }
          }
        },
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  Future<void> changeComplete(BuildContext context, Task task, bool? p0) async {
    setState(() {
      task.complete = p0 ?? false;
    });
    await context.read<DataController>().writeData();
  }

  Future<void> dismissTask(BuildContext context, Task task) async {
    final dataController = context.read<DataController>();
    final done = await dataController.deleteATask(widget.plan, task);

    if (context.mounted && done.compareTo(States.TRUE) == 0) {
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
    }
  }

  Future<void> deleteTask(BuildContext context, Task task) async {
    final dataController = context.read<DataController>();

    final isConfirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) => _confirmDelete(context));

    if (isConfirmDelete) {
      final done = await dataController.deleteATask(widget.plan, task);

      if (context.mounted && done.compareTo(States.TRUE) == 0) {
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
      }
    }
  }
//end code
}

/// Task search delegate.
class TaskSearchDelegate extends SearchDelegate {
  final Plan plan;
  final TasksList taskList;

  TaskSearchDelegate(
    this.plan,
    this.taskList,
  ) : super(
          searchFieldLabel: Language.instance.Search,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          tooltip: Language.instance.Refresh,
          icon: const Icon(Icons.replay))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        tooltip: Language.instance.Back,
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> matchQuery = [];
    for (var task in taskList.tasks) {
      if (task.description.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(task);
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        var task = matchQuery[index];
        return ListTile(
          leading: CircleAvatar(
              backgroundColor:
                  Themes.instance.DrawerItemCompleteContentColor(task.complete),
              child: Text(plan.name[0])),
          title: Text(task.description,
              style: Themes.instance.DrawerItemContentTextStyle(task.complete)),
          onTap: () => Navigator.pushNamed(context, TaskEditPage.routeName,
              arguments: TaskPageArguments(plan, task)),
        );
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Task> matchQuery = [];

    for (var task in taskList.tasks) {
      if (task.description.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(task);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var task = matchQuery[index];
        return ListTile(
          leading: CircleAvatar(
              backgroundColor:
                  Themes.instance.DrawerItemCompleteContentColor(task.complete),
              child: Text(plan.name[0])),
          title: Text(task.description,
              style: Themes.instance.DrawerItemContentTextStyle(task.complete)),
          onTap: () => Navigator.pushNamed(context, TaskEditPage.routeName,
              arguments: TaskPageArguments(plan, task)),
        );
      },
      itemCount: matchQuery.length,
    );
  }
//end code
}
