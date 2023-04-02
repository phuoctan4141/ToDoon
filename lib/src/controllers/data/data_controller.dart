// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todoon/src/app/ToDoon.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/controllers/notifications/notifications_controller.dart';
import 'package:todoon/src/models/data_model.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/routes/routes.dart';
import 'package:todoon/src/utils/file_manager.dart';
import 'package:todoon/src/views/data/plans/pages/plans_page.dart';
import 'package:todoon/src/views/data/tasks/pages/tasks_page.dart';

/// Data Controller for the application.
class DataController
    with ChangeNotifier
    implements DataHandle, NoticeHandle, DateTimeHandle {
  /// [Data] object singleton instance.
  static DataController instance = DataController();

  /// Data Handle Model object.
  static final DataModel dataModel = DataModel();

  /// isFirstTime.
  static bool isFirstTime = false;

  /// Initial [data] for the application.
  static Future<void> initialize() async {
    String state = await instance.fetandcreateJsonFile;
    if (state.compareTo(States.CREATED_FILE) == 0) {
      isFirstTime = true;
    }
  }

  /// Fet & Create [data.json] file from the storage.
  /// @return [String] state.
  @override
  Future<String> get fetandcreateJsonFile async {
    String state = States.FALSE;

    state = await FileManager.instance
        .createJsonFile(States.FOLDER_APP, States.DATA_FILE);

    if (state.compareTo(States.CREATED_FILE) == 0) {
      final jsonContent = await rootBundle.loadString('assets/data/data.json');
      final jsonResponse = json.decode(jsonContent);

      dataModel.setMemoryCache(PlansList.fromJson(jsonResponse));
      dataModel.setStorage(PlansList.fromJson(jsonResponse));

      await FileManager.instance.writeJsonFile(
          States.FOLDER_APP, States.DATA_FILE, dataModel.getDataStorage);
    }

    notifyListeners();
    return state;
  }

  /// Load [data] to the dataModel from the storage.
  /// @return [String] state.
  @override
  Future<String> get loadData async {
    final jsonResponse = await FileManager.instance
        .readJsonFile(States.FOLDER_APP, States.DATA_FILE);

    if (jsonResponse != null) {
      dataModel.setMemoryCache(PlansList.fromJson(jsonResponse));
      dataModel.setStorage(PlansList.fromJson(jsonResponse));
      notifyListeners();
      return States.TRUE;
    } else {
      return States.FALSE;
    }
  }

  /// Write [data] to storage from the dataModel.
  Future<void> get writeData async {
    await FileManager.instance.writeJsonFile(
        States.FOLDER_APP, States.DATA_FILE, dataModel.getDataStorage);

    notifyListeners();
  }

  /// Get [data] from the dataModel.
  /// @return [PlansList] object.
  PlansList get getData => dataModel.getPlansList;

  /// Get [plansListToday] from the dataModel.
  /// @return [PlansList] object.
  PlansList get getDataToday => dataModel.plansListToday;

  /// Get [tasksToday] from the dataModel.
  /// @return [List<Task>] object.
  List<Task> getTasksToday(List<Task> tasks) =>
      dataModel.getTasksToday(tasks) ?? [];

  /// Get [tasksList] from the dataModel.
  /// @return [TasksList] object.
  TasksList getTasksList(Plan plan) => dataModel.getTasksList(plan);

  /// Get [not complete Taskslist] from the dataModel.
  /// @return [TasksList] object.
  TasksList getNotCompleteTasksList(TasksList tasksList) =>
      dataModel.notTasksList(tasksList);

  /// Get [complete Taskslist] from the dataModel.
  /// @return [TasksList] object.
  TasksList getCompleteTasksList(TasksList tasksList) =>
      dataModel.comTasksList(tasksList);

  /// Get [deadline TasksList] from the dataModel.
  /// @return [TasksList] object.
  TasksList getDeadlineTasksList(TasksList tasksList) =>
      dataModel.deadTasksList(tasksList);

  /// Get [List<Plan>] from the dataModel.
  /// @return [List<Plan>] object.
  List<Plan> get getAllPlans => dataModel.getAllPlans;

  /// Get [Plan] from the dataModel.
  /// @return [Plan] object.
  Plan? getPlanById(int id) => dataModel.getPlan(id);

  /// Get [Task] from the dataModel.
  /// @return [Task] object.
  Task? getTaskById(Plan plan, int id) => dataModel.getTask(plan, id);

  /// Get [Task] from the dataModel.
  /// @return [Task] object.
  Task? getLastTask(Plan plan) => dataModel.getLastTask(plan);

  /// This method adds a new task.
  /// @return [String] state.
  @override
  Future<String> doAddNewPlan(String name) async {
    try {
      if (name.isEmpty) {
        return States.FALSE;
      } else {
        // Create a new plan.
        dataModel.createPlan(name: name);
        // Write to storage.
        await writeData;

        return States.TRUE;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// This method edits a plan.
  /// @return [String] state.
  @override
  Future<String> doEditPlan(Plan plan, String name) async {
    try {
      if (name.isEmpty) {
        return States.FALSE;
      } else {
        // Update the name to a plan.
        plan.name = name;
        dataModel.updatePlan(plan);
        // Write to storage.
        await writeData;

        return States.TRUE;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// This method deletes a plan.
  /// @return [String] state.
  @override
  Future<String> doDeletePlan(Plan plan) async {
    try {
      //Delete all notifications.
      for (var task in plan.tasks) {
        if (task.alert == true) {
          NotificationsController.cancelScheduledNotificationsById(task.id);
          NotificationsController.dismissNotificationsById(task.id);
        }
      }
      // Delete a plan.
      dataModel.deletePlan(plan);
      // Write to storage.
      await writeData;

      return States.TRUE;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// This method adds a new task and a due date notification.
  /// @return [String] state.
  @override
  Future<String> doAddNewTask(Plan plan,
      {String description = '',
      String date = '',
      String reminder = '',
      bool complete = false,
      bool alert = false}) async {
    try {
      // Ensure that the task has a description.
      if (description.isEmpty) {
        return States.FALSE;
      } else {
        // Create a new task.
        dataModel.createTask(plan,
            description: description, date: date, reminder: reminder);
        // Create a due date for the notification.
        var _task = getLastTask(plan);
        if (_task != null) {
          var date = Iso8601toDateTime(_task.date);
          if (date != null && date.isAfter(DateTime.now())) {
            NotificationsController.createTaskDeadlineNotification(
                plan, _task, date);
          }
        }

        // Write to storage.
        await writeData;

        return States.TRUE;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// This method edits a task.
  /// @return [String] state.
  @override
  Future<String> doEditTask(Plan plan, Task task) async {
    try {
      if (task.description.isEmpty) return States.CANT_WRITE_FILE;

      final done = dataModel.updateTask(plan, task);

      if (done == 0) {
        return States.FALSE;
      } else if (done == 1) {
        // Write to storage.
        await writeData;
        return States.TRUE;
      } else {
        return States.CANT_WRITE_FILE;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// This method deletes a task and a notification of the task.
  /// @return [String] state.
  @override
  Future<String> doDeleteTask(Plan plan, Task task) async {
    try {
      // Delete a notification.
      NotificationsController.cancelScheduledNotificationsById(task.id);
      NotificationsController.dismissNotificationsById(task.id);

      // Delete a task.
      dataModel.deleteTask(plan, task);

      // Write to storage.
      await writeData;

      return States.TRUE;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Handle the notification.
  /// @route [TasksPage].
  @override
  Future<void> onComplete(ReceivedAction receivedAction) async {
    var payload = receivedAction.payload;
    if (payload != null) {
      loadData.then((value) async {
        var idPlan = payload['plan'];
        var idTask = payload['task'];
        if (idPlan != null && idTask != null) {
          var plan = dataModel.getPlan(int.parse(idPlan));
          if (plan != null) {
            var task = dataModel.getTask(plan, int.parse(idTask));
            if (task != null) {
              Task _task = task;
              _task.reminder = payload['deadline'] == States.TRUE
                  ? task.reminder
                  : States.NOTICE_NULL;
              _task.complete = true;
              _task.alert = false;
              dataModel.updateTask(plan, task);
              await writeData.then((value) {
                ToDoon.navigatorKey.currentState!.pushAndRemoveUntil<void>(
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => TasksPage(plan: plan)),
                  ModalRoute.withName(PAGE_HOME),
                );
              });
            }
          }
        }
      });
    }
  }

  /// Handle the notification.
  /// @route [TasksPage].
  @override
  Future<void> onCompleteBackground(ReceivedAction receivedAction) async {
    print('onBackground data');
    var payload = receivedAction.payload;
    if (payload != null) {
      loadData.then((value) async {
        var idPlan = payload['plan'];
        var idTask = payload['task'];
        if (idPlan != null && idTask != null) {
          var plan = dataModel.getPlan(int.parse(idPlan));
          if (plan != null) {
            var task = dataModel.getTask(plan, int.parse(idTask));
            if (task != null) {
              Task _task = task;
              _task.reminder = payload['deadline'] == States.TRUE
                  ? task.reminder
                  : States.NOTICE_NULL;
              _task.complete = true;
              _task.alert = false;
              dataModel.updateTask(plan, task);
              await writeData.then((value) {
                ToDoon.navigatorKey.currentState!.pushAndRemoveUntil<void>(
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => TasksPage(plan: plan)),
                  ModalRoute.withName(PAGE_HOME),
                );
              });
            }
          }
        }
      });
    }
  }

  /// Handle the notification.
  /// This method is called when the notification is displayed.
  @override
  Future<void> onDisplayed(ReceivedNotification receivedNotification,
      NavigatorState currentState) async {
    var payload = receivedNotification.payload;
    if (payload != null) {
      var idPlan = payload['plan'];
      var idTask = payload['task'];
      if (idPlan != null && idTask != null) {
        var plan = dataModel.getPlan(int.parse(idPlan));
        if (plan != null) {
          var task = dataModel.getTask(plan, int.parse(idTask));
          if (task != null) {
            Task _task = task;
            _task.reminder = payload['deadline'] == States.TRUE
                ? task.reminder
                : States.NOTICE_NULL;
            _task.complete = task.complete;
            _task.alert = false;
            dataModel.updateTask(plan, _task);
            await writeData;
          }
        }
      }
    }
  }

  /// MaterialPageRoute when app opened.
  /// @route [TasksPage].
  @override
  MaterialPageRoute onAppKilled(ReceivedAction receivedAction) {
    var payload = receivedAction.payload;
    if (payload != null) {
      loadData.then((value) {
        var idPlan = payload['plan'];
        if (idPlan != null) {
          var plan = dataModel.getPlan(int.parse(idPlan));
          if (plan != null) {
            return MaterialPageRoute(builder: (_) => TasksPage(plan: plan));
          }
        }
      });
    }
    return MaterialPageRoute(builder: (_) => PlansPage());
  }

  /// Handle the notification.
  /// This method is called when the notification is dismissed.
  @override
  Future<void> onDismiss(ReceivedAction receivedAction) async {
    print('onDismiss data');
    var payload = receivedAction.payload;
    if (payload != null) {
      loadData.then((value) async {
        var idPlan = payload['plan'];
        var idTask = payload['task'];
        if (idPlan != null && idTask != null) {
          var plan = dataModel.getPlan(int.parse(idPlan));
          if (plan != null) {
            var task = dataModel.getTask(plan, int.parse(idTask));
            if (task != null) {
              Task _task = task;
              _task.reminder = task.reminder;
              _task.complete = task.complete;
              _task.alert = false;
              dataModel.updateTask(plan, task);
              await writeData.then((value) {});
            }
          }
        }
      });
    }
  }

  /// Format Iso8601 to String by current location.
  /// @return [String].
  @override
  String Iso8601toString(String? formattedString) {
    if (formattedString!.isNotEmpty && formattedString != States.NOTICE_NULL) {
      DateTime datetime = DateTime.parse(formattedString);
      initializeDateFormatting(Language.instance.current.code, null);

      return DateFormat.yMd(Language.instance.current.code)
          .add_jms()
          .format(datetime);
    }

    return States.NOTICE_NULL;
  }

  /// Format Iso8601 to DateTime by current location.
  /// @return [DateTime].
  @override
  DateTime? Iso8601toDateTime(String? formattedString) {
    if (formattedString!.isNotEmpty && formattedString != States.NOTICE_NULL) {
      DateTime datetime = DateTime.parse(formattedString);
      return datetime;
    }

    return null;
  }

  /// Format String to Iso8601 by current location.
  /// @return [String].
  @override
  String StringtoIso8601(String? inputString) {
    try {
      if (inputString!.isNotEmpty && inputString != "(O.O)") {
        initializeDateFormatting(Language.instance.current.code, null);
        DateTime datetime = DateFormat.yMd(Language.instance.current.code)
            .add_jms()
            .parse(inputString);

        return datetime.toIso8601String();
      }
    } catch (e) {
      throw Exception(e);
    }

    return States.NOTICE_NULL;
  }

  /// Format String to DateTime by current location.
  /// @return [DateTime].
  @override
  DateTime? StringtoDateTime(String? inputString) {
    try {
      if (inputString!.isNotEmpty && inputString != "(O.O)") {
        initializeDateFormatting(Language.instance.current.code, null);
        DateTime datetime = DateFormat.yMd(Language.instance.current.code)
            .add_jms()
            .parse(inputString);

        return datetime;
      }
    } catch (e) {
      throw Exception(e);
    }

    return null;
  }

  /// Format DateTime to String by current location.
  /// @return [String].
  @override
  String DateTimetoString(DateTime? dateTime) {
    if (dateTime != null) {
      try {
        initializeDateFormatting(Language.instance.current.code, null);
        return DateFormat.yMd(Language.instance.current.code)
            .add_jms()
            .format(dateTime);
      } catch (e) {
        throw Exception(e);
      }
    }

    return States.NOTICE_NULL;
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}

/// Data model.
abstract class DataHandle {
  // Data model methods.
  Future<String> get fetandcreateJsonFile;
  Future<String> get loadData;
  // Plan model methods.
  Future<String> doAddNewPlan(String name);
  Future<String> doEditPlan(Plan plan, String name);
  Future<String> doDeletePlan(Plan plan);
  // Task model methods.
  Future<String> doAddNewTask(Plan plan,
      {String description = '',
      String date = '',
      String reminder = '',
      bool complete = false,
      bool alert = false});
  Future<String> doEditTask(Plan plan, Task task);
  Future<String> doDeleteTask(Plan plan, Task task);
}

/// Notification model.
abstract class NoticeHandle {
  Future<void> onComplete(ReceivedAction receivedAction);
  Future<void> onCompleteBackground(ReceivedAction receivedAction);
  Future<void> onDisplayed(
      ReceivedNotification receivedNotification, NavigatorState currentState);
  MaterialPageRoute onAppKilled(ReceivedAction receivedAction);
  Future<void> onDismiss(ReceivedAction receivedAction);
}

/// DateTime model.
abstract class DateTimeHandle {
  String Iso8601toString(String? formattedString);
  DateTime? Iso8601toDateTime(String? formattedString);
  String StringtoIso8601(String? inputString);
  DateTime? StringtoDateTime(String? inputString);
  String DateTimetoString(DateTime? dateTime);
}
