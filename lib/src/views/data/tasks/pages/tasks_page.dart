// ignore_for_file: public_member_api_docs, sort_constructors_first, no_leading_underscores_for_local_identifiers
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/notifications/notifications_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/routes/routes.dart';
import 'package:todoon/src/views/data/tasks/components/tasks_components.dart';
import 'package:todoon/src/views/data/tasks/pages/task_edit_page.dart';
import 'package:todoon/src/views/widgets/back_button_widget.dart';
import 'package:todoon/src/views/widgets/complete_count_tasks.dart';
import 'package:todoon/src/views/widgets/drawer_widget.dart';
import 'package:todoon/src/views/widgets/empty_icon_widget.dart';
import 'package:todoon/src/views/widgets/status_bar_widget.dart';
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

  DateTime? _dateTime;

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
        final taskList = dataController.getTasksList(widget.plan);
        return WillPopScope(
          onWillPop: () => Future.value(true),
          child: Scaffold(
            appBar: AppBar(
              leading: const BackButtonWidget(),
              title: Text(widget.plan.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              actions: [
                _editPlan(context, widget.plan),
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

  Widget _buildDrawer(BuildContext context) {
    final plans = context.read<DataController>().getAllPlans;
    // ignore: avoid_unnecessary_containers
    return PlansDrawer(
        plans: plans, plan: widget.plan, scrollController: scrollController);
  }

  Widget _completeCountTask(BuildContext context, TasksList tasksList) {
    return CompleteCountTasks(tasksList: tasksList);
  }

  Widget _buildTasksList(BuildContext context, TasksList tasksList) {
    return tasksList.tasks.isEmpty
        // ignore: prefer_const_constructors
        ? Center(child: EmptyIconWidget())
        : _buildContentTaskstList(context, tasksList);
  }

  Widget _buildContentTaskstList(BuildContext context, TasksList tasksList) {
    final notTasksList =
        DataController.instance.getNotCompleteTasksList(tasksList);
    final comTasksList =
        DataController.instance.getCompleteTasksList(tasksList);
    final deadTasksList =
        DataController.instance.getDeadlineTasksList(tasksList);
    final width = MediaQuery.of(context).size.width;

    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        /// Status bar.
        SliverAppBar(
          pinned: true,
          snap: true,
          stretch: true,
          floating: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          elevation: 6.0,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            expandedTitleScale: 1.0,
            title: StatusBarWidget(
                width: width - 16,
                height: 30,
                deadTasksList: deadTasksList,
                notTasksList: notTasksList,
                comTasksList: comTasksList),
            background: Material(
              color: Colors.transparent,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 3),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),

        /// Deadline tasksList.
        SliverList(
          delegate: SliverChildBuilderDelegate(
              childCount: deadTasksList.tasks.length, (context, indexTask) {
            return _buildTaskTile(context, deadTasksList.tasks, indexTask);
          }),
        ),

        /// Not complete tasks.
        SliverList(
          delegate: SliverChildBuilderDelegate(
              childCount: notTasksList.tasks.length, (context, indexTask) {
            return _buildTaskTile(context, notTasksList.tasks, indexTask);
          }),
        ),

        /// Complete task
        SliverList(
          delegate: SliverChildBuilderDelegate(
              childCount: comTasksList.tasks.length, (context, indexTask) {
            return _buildTaskTile(context, comTasksList.tasks, indexTask);
          }),
        ),
        // Complete task.
      ],
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
      alert: task.alert,
      onAlert: () => updateAlert(context, task),
      onEdit: () => _routeTask(context, task),
      onDelete: () => deleteTask(context, task),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async => await addNewTask(context),
      tooltip: Language.instance.Add_Task,
      child: const Icon(ToDoonIcons.add_task),
    );
  }

  Widget _editPlan(BuildContext context, Plan plan) {
    return IconButton(
        tooltip: Language.instance.Edit_Plan,
        onPressed: () => editPlan(context, plan),
        icon: const Icon(ToDoonIcons.edit_plan));
  }

  Widget _confirmDelete(BuildContext context) {
    return const AlertDeleteTask();
  }

  // ignore: non_constant_identifier_names
  Widget _TaskReminderAlert(BuildContext context) {
    return TaskItem(
      title: Language.instance.Reminder,
      minLines: 1,
      maxLines: 1,
      readOnly: true,
      controller: textEditingReminder,
      child: IconButton(
        icon: const Icon(ToDoonIcons.add_reminder),
        onPressed: () => changeReminderAlert(context),
      ),
    );
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
            final done = await dataController.doEditPlan(plan, name);

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

          final done = await dataController.doAddNewTask(widget.plan,
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

  Future<void> dismissTask(BuildContext context, Task task) async {
    final dataController = context.read<DataController>();
    final done = await dataController.doDeleteTask(widget.plan, task);

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
      final done = await dataController.doDeleteTask(widget.plan, task);

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

  Future<void> updateAlert(BuildContext context, Task task) async {
    if (task.alert == false) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertNoticeTask(
                content: Container(
                  child: _TaskReminderAlert(context),
                ),
                onNotice: () async => onNotice(context, task),
                onCancel: () => Navigator.of(context).pop(false));
          });
    } else {
      //Cancel a notification.
      NotificationsController.cancelScheduledNotificationsById(task.id);

      final done = await doUpdateAlert(context, task,
          textReminder: States.NOTICE_NULL, alert: false);
      if (context.mounted && done.compareTo(States.TRUE) == 0) {
        // Show snackbar.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '${Language.instance.Alert} ${Language.instance.Cancel}',
            overflow: TextOverflow.ellipsis,
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 1),
        ));
      }
    }
  }

  Future<String> doUpdateAlert(BuildContext context, Task task,
      {required String textReminder, required bool alert}) async {
    //Update a task.
    final _reminder = DataController.instance.StringtoIso8601(textReminder);

    final _task = Task(
        id: task.id,
        description: task.description,
        date: task.date,
        reminder: _reminder,
        complete: task.complete,
        alert: alert);
    return await DataController.instance.doEditTask(widget.plan, _task);
  }

  Future<void> onNotice(BuildContext context, Task task) async {
    if (_dateTime != null) {
      if (_dateTime!.isBefore(DateTime.now())) {
        // Show snackbar.
        wrongWidget(context);
      }

      final String done = await doUpdateAlert(context, task,
          textReminder: textEditingReminder.text, alert: true);

      if (context.mounted && done.compareTo(States.TRUE) == 0) {
        // Create a notification.
        NotificationsController.createTaskReminderNotification(
            widget.plan, task, _dateTime!);
        // Set _alert is true.
        Navigator.of(context).pop();
        // Show snackbar.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '${Language.instance.Alert} ${Language.instance.Task}',
            overflow: TextOverflow.ellipsis,
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 1),
        ));
      } else {
        // Show snackbar.
        wrongWidget(context);
      }
    } else {
      // Show snackbar.
      wrongWidget(context);
    }
  }

  Future<void> changeComplete(BuildContext context, Task task, bool? p0) async {
    setState(() {
      task.complete = p0 ?? false;
    });
    await context.read<DataController>().writeData;
  }

  void changeReminderAlert(BuildContext context) {
    final currentTime = DateTime.now();
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: currentTime.add(const Duration(minutes: 1)),
      maxTime: DateTime(2050, 12, 31),
      locale: Language.instance.getLocaleType,
      theme: Themes.instance.DatetimePickerTheme,
      onConfirm: (dateTime) async {
        if (dateTime.isAfter(currentTime)) {
          initializeDateFormatting(Language.instance.current.code, null);
          textEditingReminder.text =
              DataController.instance.DateTimetoString(dateTime);
          _dateTime = dateTime;
        }
      },
    );
  }

// end code
}
