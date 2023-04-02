// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unused_local_variable
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
import 'package:todoon/src/views/widgets/back_button_widget.dart';
import 'package:todoon/src/views/widgets/drawer_widget.dart';
import 'package:todoon/src/views/widgets/settings_button_widget.dart';
import 'package:todoon/src/views/widgets/switch_widget.dart';
import 'package:todoon/src/views/widgets/wrong_widget.dart';

class TaskEditPage extends StatefulWidget {
  // The navigator key is necessary to navigate using static methods.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const routeName = PAGE_TASK;
  final Plan plan;
  final Task task;

  // ignore: prefer_const_constructors_in_immutables
  TaskEditPage({
    Key? key,
    required this.plan,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  late Plan plan;
  late Task task;
  late DataController dataController;

  late ScrollController scrollController;
  late FocusNode fieldNode;

  late TextEditingController textEditingDecription;
  late TextEditingController textEditingDate;
  late TextEditingController textEditingReminder;
  late bool _complete = false;
  late bool _alert = false;
  DateTime? _dateTime;

  double? height;
  double? width;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    fieldNode = FocusNode();

    textEditingDecription = TextEditingController();
    textEditingDate = TextEditingController();
    textEditingReminder = TextEditingController();

    dataController = Provider.of<DataController>(context, listen: false);
    plan = dataController.getPlanById(widget.plan.id)!;
    task = dataController.getTaskById(plan, widget.task.id)!;

    textEditingDecription.text = task.description;
    textEditingDate.text = DataController.instance.Iso8601toString(task.date);
    textEditingReminder.text =
        DataController.instance.Iso8601toString(task.reminder);
    _complete = task.complete;
    _alert = task.alert;
  }

  @override
  void didChangeDependencies() {
    final _dataController = Provider.of<DataController>(context, listen: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      plan = _dataController.getPlanById(widget.plan.id)!;
      task = _dataController.getTaskById(plan, widget.task.id)!;
      if ((_alert == false) || (task.alert != _alert && _alert == true)) {
        if (task.reminder == '(O.O)') {
          textEditingReminder.text =
              DataController.instance.Iso8601toString(task.reminder);
        }
        _complete = task.complete;
        _alert = task.alert;
        if (mounted) {
          setState(() {});
        }
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    fieldNode.dispose();
    scrollController.dispose();
    textEditingDecription.dispose();
    textEditingDate.dispose();
    textEditingReminder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: GestureDetector(
        onTap: () => fieldNode.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            // ignore: prefer_const_constructors
            leading: BackButtonWidget(),
            title: Text(plan.name.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            // ignore: prefer_const_literals_to_create_immutables
            actions: [
              _EditPlan(context, widget.plan),
              // ignore: prefer_const_constructors
              SettingsButtonWidget(),
            ],
          ),
          drawer: DrawerWidget(
              content: _buildDrawer(context), focusNode: fieldNode),
          body: SingleChildScrollView(child: _bodyTask(context)),
        ),
      ),
    );
  }

  /////////////////////////////
  // View Widgets  ////////////
  // View Widgets /////////////
  /////////////////////////////

  _buildDrawer(BuildContext context) {
    final tasks = plan.tasks;
    // ignore: avoid_unnecessary_containers
    return TasksDrawer(
      plan: plan,
      tasks: tasks,
      task: task,
      scrollController: scrollController,
    );
  }

  Widget _bodyTask(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Card(
      child: Column(
        children: <Widget>[
          // Content of the task.
          Column(
            children: <Widget>[
              _TaskDecription(context),
              _TaskDate(context),
              _TaskReminder(context),
              //const Divider(thickness: 3, indent: 20, endIndent: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _TaskComplete(context),
                  _TaskAlert(context),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
          // Action edit task.
          const SizedBox(height: 8),
          SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _CancelEdit(context),
                const SizedBox(width: 8),
                _AcceptEdit(context),
              ],
            ),
          ),
          const SizedBox(height: 8),
          //_adsContainer(context),
        ],
      ),
    );
  }

  Widget _TaskDecription(BuildContext context) {
    return TaskItem(
      title: Language.instance.Description,
      maxLength: 128,
      maxLines: 1,
      minLines: 1,
      controller: textEditingDecription,
      focusNode: fieldNode,
      hintText: Language.instance.New_Task,
    );
  }

  Widget _TaskDate(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: TaskItem(
        title: Language.instance.Date,
        minLines: 1,
        maxLines: 1,
        readOnly: true,
        controller: textEditingDate,
        keyboardType: TextInputType.datetime,
        child: IconButton(
          onPressed: () => changeDate(context),
          icon: const Icon(ToDoonIcons.dueDate),
        ),
      ),
      onTap: () => changeDate(context),
    );
  }

  Widget _TaskReminder(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: TaskItem(
        title: Language.instance.Reminder,
        minLines: 1,
        maxLines: 1,
        readOnly: true,
        controller: textEditingReminder,
        keyboardType: TextInputType.datetime,
        child: IconButton(
          onPressed: () async {
            changeReminder(context);
          },
          icon: const Icon(ToDoonIcons.reminder),
        ),
      ),
      onTap: () async {
        changeReminder(context);
      },
    );
  }

  Widget _TaskComplete(BuildContext context) {
    return SwitchWidget(
        title: Text(Language.instance.Complete,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        value: _complete,
        activeText: Language.instance.Complete,
        inactiveText: Language.instance.Off,
        width: 135,
        onChanged: (value) async {
          setState(() {
            _complete = value;
          });

          await updateATask(context);
        });
  }

  Widget _TaskAlert(BuildContext context) {
    return SwitchWidget(
        title: Text(Language.instance.Alert,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        value: _alert,
        activeText: Language.instance.Alert,
        inactiveText: Language.instance.Off,
        width: 130,
        onChanged: (value) async {
          setState(() {
            _alert = value;
          });

          await changeAlert(context);
        });
  }

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

  Widget _CancelEdit(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height! / 18,
        minWidth: width! / 2 - 20,
      ),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(ToDoonIcons.cancel),
        label: Text(Language.instance.Cancel),
      ),
    );
  }

  Widget _AcceptEdit(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height! / 18,
        minWidth: width! / 2 - 20,
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          await acceptEditTask(context);
        },
        icon: const Icon(ToDoonIcons.edit_task),
        label: Text(Language.instance.OK),
        style: Themes.instance.AddButtonStyle,
      ),
    );
  }

  Widget _EditPlan(BuildContext context, Plan plan) {
    return IconButton(
        tooltip: Language.instance.Edit_Plan,
        onPressed: () => editPlan(context, plan),
        icon: const Icon(ToDoonIcons.edit_plan));
  }

  /////////////////////////////
  // View handle  /////////////
  // View handle //////////////
  /////////////////////////////

  void changeDate(BuildContext context) {
    final currentTime = DateTime.now();
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: currentTime,
      maxTime: DateTime(2050, 12, 31),
      theme: Themes.instance.DatetimePickerTheme,
      locale: Language.instance.getLocaleType,
      onConfirm: (dateTime) {
        initializeDateFormatting(Language.instance.current.code, null);
        textEditingDate.text =
            DataController.instance.DateTimetoString(dateTime);
      },
    );
  }

  void changeReminder(BuildContext context) {
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
          NotificationsController.cancelScheduledNotificationsById(task.id);
          final done = await onUpdateAlert(context);
          if (context.mounted && done.compareTo(States.TRUE) == 0) {
            // update _alert is false.
            setState(() {
              _alert = false;
            });
          }
        }
      },
    );
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

  Future<void> editPlan(BuildContext context, Plan plan) async {
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

  Future<void> acceptEditTask(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertEditTask(
              onEdit: () async {
                final done = await updateATask(context);
                if (context.mounted) {
                  switch (done) {
                    case States.TRUE:
                      {
                        // Create notification.
                        onDeadlineNotice(context);
                        Navigator.of(context).pop(true);
                        // Show snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            '${Language.instance.Complete} ${Language.instance.Edit}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(10),
                          duration: const Duration(seconds: 1),
                        ));
                      }
                      break;
                    case States.FALSE:
                      {
                        Navigator.of(context).pop(false);
                        break;
                      }

                    default:
                      {
                        Navigator.of(context).pop(false);
                        wrongWidget(context);
                        break;
                      }
                  }
                }
              },
              onCancel: () => Navigator.of(context).pop(false));
        });
  }

  Future<String> updateATask(BuildContext context) async {
    final _description = textEditingDecription.text;
    final _date = dataController.StringtoIso8601(textEditingDate.text);
    final _reminder = dataController.StringtoIso8601(textEditingReminder.text);

    final _task = Task(
        id: task.id,
        description: _description,
        date: _date,
        reminder: _reminder,
        complete: _complete,
        alert: task.alert);

    return await dataController.doEditTask(plan, _task);
  }

  Future<void> onDeadlineNotice(BuildContext context) async {
    // Create notification.
    final _task = dataController.getTaskById(widget.plan, task.id);
    final date = DataController.instance.Iso8601toDateTime(_task?.date);
    if (date != null && date.isAfter(DateTime.now())) {
      NotificationsController.createTaskDeadlineNotification(
          widget.plan, widget.task, date);
    }
  }

  Future<void> changeAlert(BuildContext context) async {
    if (_alert) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertNoticeTask(
                content: Container(
                  child: _TaskReminderAlert(context),
                ),
                onNotice: () async => onNotice(context),
                onCancel: () {
                  Navigator.of(context).pop(false);
                  setState(() {
                    _alert = false;
                  });
                });
          });
    } else {
      //Cancel a notification.
      NotificationsController.cancelScheduledNotificationsById(task.id);
      //Update a task.
      final done = await onUpdateAlert(context);
      if (context.mounted && done.compareTo(States.TRUE) == 0) {
        // update _alert is false.
        setState(() {
          _alert = false;
        });
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

  Future<void> onNotice(BuildContext context) async {
    if (_dateTime != null) {
      final _description = textEditingDecription.text;
      final _date = dataController.StringtoIso8601(textEditingDate.text);
      final _reminder =
          dataController.StringtoIso8601(textEditingReminder.text);

      final _task = Task(
          id: task.id,
          description: _description,
          date: _date,
          reminder: _reminder,
          complete: _complete,
          alert: true);
      final done = await dataController.doEditTask(plan, _task);

      if (context.mounted && done.compareTo(States.TRUE) == 0) {
        // Create a notification.
        NotificationsController.createTaskReminderNotification(
            plan, task, _dateTime!);
        // Set _alert is true.
        Navigator.of(context).pop();
        setState(() {
          _alert = true;
        });
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
      }
    } else {
      // Set _alert is false.
      setState(() {
        _alert = false;
      });
      // Show snackbar.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          Language.instance.Wrong,
          overflow: TextOverflow.ellipsis,
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  Future<String> onUpdateAlert(BuildContext context) async {
    //Update a task.
    final _description = textEditingDecription.text;
    final _date = dataController.StringtoIso8601(textEditingDate.text);
    final _reminder = dataController.StringtoIso8601(textEditingReminder.text);

    final _task = Task(
        id: task.id,
        description: _description,
        date: _date,
        reminder: _reminder,
        complete: _complete,
        alert: false);
    return await dataController.doEditTask(plan, _task);
  }
//end code
}
