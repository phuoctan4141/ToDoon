// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/notifications/notifications_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/data/tasks/components/task_item.dart';
import 'package:todoon/src/views/data/tasks/components/tasks_drawer.dart';
import 'package:todoon/src/views/widgets/back_button_widget.dart';
import 'package:todoon/src/views/widgets/drawer_widget.dart';
import 'package:todoon/src/views/widgets/settings_button_widget.dart';
import 'package:todoon/src/views/widgets/switch_widget.dart';
import 'package:todoon/src/views/widgets/wrong_widget.dart';

class TaskEditPage extends StatefulWidget {
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
  Plan get plan => widget.plan;
  Task get task => widget.task;

  late ScrollController scrollController;

  late TextEditingController textEditingDecription;
  late TextEditingController textEditingDate;
  late TextEditingController textEditingReminder;
  late bool _complete = false;
  late bool _alert = false;

  double? height;
  double? width;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    textEditingDecription = TextEditingController();
    textEditingDate = TextEditingController();
    textEditingReminder = TextEditingController();

    setState(() {
      textEditingDecription.text = task.description;
      textEditingDate.text = DataController.instance.Iso8601toString(task.date);
      textEditingReminder.text =
          DataController.instance.Iso8601toString(task.reminder);
      _complete = task.complete;
      _alert = task.alert;
    });
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
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          leading: BackButtonWidget(),
          title: Text(plan.name.toString()),
          // ignore: prefer_const_literals_to_create_immutables
          actions: [
            // ignore: prefer_const_constructors
            SettingsButtonWidget(),
          ],
        ),
        drawer: DrawerWidget(content: _buildDrawer(context)),
        body: SingleChildScrollView(child: _bodyTask(context)),
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
        scrollController: scrollController);
  }

  Widget _bodyTask(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        // Content of the task.
        GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Card(
            child: Column(
              children: <Widget>[
                _TaskDecription(context),
                _TaskDate(context),
                _TaskReminder(context),
                // const Divider(thickness: 3, indent: 20, endIndent: 20),
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
          ),
        ),
        // Action edit task.
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 10),
            _CancelEdit(context),
            const SizedBox(width: 8),
            _AcceptEdit(context),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  Widget _TaskDecription(BuildContext context) {
    return TaskItem(
      title: Language.instance.Description,
      maxLength: 128,
      maxLines: 1,
      minLines: 1,
      controller: textEditingDecription,
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
        child: IconButton(
          onPressed: () => changeDate(context),
          icon: const Icon(Icons.calendar_month_outlined),
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
        child: IconButton(
          onPressed: () => changeReminder(context),
          icon: const Icon(Icons.event_available_outlined),
        ),
      ),
      onTap: () => changeReminder(context),
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
        onChanged: (value) {
          setState(() {
            _complete = value;
          });
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
          await changeAlert(context);
          setState(() {
            _alert = value;
          });
        });
  }

  Widget _CancelEdit(BuildContext context) {
    return SizedBox(
      width: 125,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.cancel),
        label: Text(Language.instance.Cancel),
      ),
    );
  }

  Widget _AcceptEdit(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        onPressed: () async {
          await acceptEditTask(context);
        },
        icon: const Icon(Icons.edit_note),
        label: Text(Language.instance.Edit_Task),
        style: Themes.instance.AddButtonStyle,
      ),
    );
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
      minTime: currentTime,
      maxTime: DateTime(2050, 12, 31),
      locale: Language.instance.getLocaleType,
      theme: Themes.instance.DatetimePickerTheme,
      onConfirm: (dateTime) {
        if (dateTime.isAfter(currentTime)) {
          initializeDateFormatting(Language.instance.current.code, null);
          textEditingReminder.text =
              DataController.instance.DateTimetoString(dateTime);
        }
      },
    );
  }

  Future<void> acceptEditTask(BuildContext context) async {
    final dataController = context.read<DataController>();

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Language.instance.Edit_Task),
            actionsAlignment: MainAxisAlignment.center,
            content: Text(Language.instance.Edit_Sure),
            actions: [
              // Cancel edit task.
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.cancel),
                label: Text(Language.instance.Cancel),
              ),
              // Accept edit task.
              ElevatedButton.icon(
                onPressed: () async {
                  final _description = textEditingDecription.text;
                  final _date =
                      dataController.StringtoIso8601(textEditingDate.text);
                  final _reminder =
                      dataController.StringtoIso8601(textEditingReminder.text);

                  final _task = Task(
                      id: task.id,
                      description: _description,
                      date: _reminder,
                      reminder: _reminder,
                      complete: _complete,
                      alert: _alert);

                  if (_description.isNotEmpty && _date.isNotEmpty) {
                    final int up =
                        dataController.dataModel.updateTask(plan, _task);

                    if (up == 0) Navigator.of(context).pop(false);

                    if (up == 1) {
                      Navigator.of(context).pop(true);
                      await dataController.writeData().then(
                            (value) => setState(
                              () => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '${Language.instance.Complete} ${Language.instance.Edit}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(10),
                                duration: const Duration(seconds: 1),
                              )),
                            ),
                          );
                    }
                  } else {
                    Navigator.of(context).pop(false);
                    wrongWidget(context);
                  }
                },
                icon: const Icon(Icons.edit_note),
                label: Text(Language.instance.Edit_Task),
                style: Themes.instance.AddButtonStyle,
              ),
            ],
          );
        });
  }

  Future<void> changeAlert(BuildContext context) async {
    final noticesController = context.read<NotificationsController>();
    final Map<String, String> payload = {
      'plan': plan.id.toString(),
      'task': task.id.toString()
    };

    noticesController.createTaskReminderNotification(plan, task);
  }
}
