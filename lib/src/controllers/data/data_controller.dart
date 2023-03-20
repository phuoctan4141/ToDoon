// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/notifications/notifications_controller.dart';
import 'package:todoon/src/models/data_model.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/utils/file_manager.dart';
import 'package:todoon/src/views/ToDoon.dart';
import 'package:todoon/src/views/data/plans/plans_page.dart';
import 'package:todoon/src/views/data/tasks/tasks_page.dart';

/// Control Data application.
class DataController with ChangeNotifier {
  /// [Data] object singleton instance.
  static DataController instance = DataController();

  /// Data Handle Model.
  final DataModel dataModel = DataModel();

  late Stream<DataModel> streamData = const Stream.empty();

  /// Initial [data] for the application.
  static Future<void> initialize() async {
    await instance.fetandcreateJsonFile();
  }

  /// fet & create [data.json] file.
  Future<String> fetandcreateJsonFile() async {
    String state = States.FALSE;

    state = await FileManager.instance
        .createJsonFile(Strings.FOLDER_APP, Strings.DATA_FILE);

    if (state.compareTo(States.CREATED_FILE) == 0) {
      final jsonContent = await rootBundle.loadString('assets/data/data.json');
      final jsonResponse = json.decode(jsonContent);

      dataModel.setMemoryCache(PlansList.fromJson(jsonResponse));
      dataModel.setStorage(PlansList.fromJson(jsonResponse));

      streamData = Stream.value(dataModel);

      state = await FileManager.instance.writeJsonFile(
          Strings.FOLDER_APP, Strings.DATA_FILE, dataModel.getDataStorage);
    }

    notifyListeners();
    return state;
  }

  /// load [data] to the dataModel.
  Future<String> loadData() async {
    final jsonResponse = await FileManager.instance
        .readJsonFile(Strings.FOLDER_APP, Strings.DATA_FILE);

    if (jsonResponse != null) {
      dataModel.setMemoryCache(PlansList.fromJson(jsonResponse));
      dataModel.setStorage(PlansList.fromJson(jsonResponse));
      notifyListeners();
      return States.TRUE;
    } else {
      return States.FALSE;
    }
  }

  /// load [streamData] for the dataModel
  Stream<DataModel> get getStreamData {
    streamData = Stream.value(dataModel);
    return streamData;
  }

  Future<DataModel?> loadDataModel() async {
    final jsonResponse = await FileManager.instance
        .readJsonFile(Strings.FOLDER_APP, Strings.DATA_FILE);

    if (jsonResponse != null) {
      dataModel.setMemoryCache(PlansList.fromJson(jsonResponse));
      dataModel.setStorage(PlansList.fromJson(jsonResponse));
      return dataModel;
    } else {
      return null;
    }
  }

  /// get [dataModel] for the dataModel
  DataModel get getDataModel => dataModel;

  /// write [data] to storage.
  Future<void> writeData() async {
    await FileManager.instance.writeJsonFile(
        Strings.FOLDER_APP, Strings.DATA_FILE, dataModel.getDataStorage);

    notifyListeners();
  }

  /// Add new plan.
  Future<String> addNewPlan(String name) async {
    try {
      if (name.isEmpty) {
        return States.FALSE;
      } else {
        // Create a new plan.
        dataModel.createPlan(name: name);
        // Write to storage.
        await writeData();

        return States.TRUE;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Edit a plan.
  Future<String> editAPlan(Plan plan, String name) async {
    try {
      if (name.isEmpty) {
        return States.FALSE;
      } else {
        // Update the name to a plan.
        plan.name = name;
        dataModel.updatePlan(plan);
        // Write to storage.
        await writeData();

        return States.TRUE;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Delete a plan.
  Future<String> deleteAPlan(Plan plan) async {
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
      await writeData();

      return States.TRUE;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Add new task.
  Future<String> addNewTask(Plan plan,
      {String description = '',
      String date = '',
      String reminder = '',
      bool complete = false,
      bool alert = false}) async {
    try {
      if (description.isEmpty) {
        return States.FALSE;
      } else {
        // Create a new task.
        dataModel.createTask(plan,
            description: description, date: date, reminder: reminder);
        // Write to storage.
        await writeData();

        return States.TRUE;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Edit a task.
  Future<String> editATask(Plan plan, Task task) async {
    try {
      if (task.description.isEmpty) return States.CANT_WRITE_FILE;

      final done = dataModel.updateTask(plan, task);

      if (done == 0) {
        return States.FALSE;
      } else if (done == 1) {
        // Write to storage.
        await writeData();
        return States.TRUE;
      } else {
        return States.CANT_WRITE_FILE;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Delete a task
  Future<String> deleteATask(Plan plan, Task task) async {
    try {
      //Delete a notification.
      NotificationsController.cancelScheduledNotificationsById(task.id);
      NotificationsController.dismissNotificationsById(task.id);
      // Delete a task.
      dataModel.deleteTask(plan, task);
      // Write to storage.
      await writeData();

      return States.TRUE;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Handle notice of a task.
  Future<void> onComplete(dynamic receivedAction) async {
    var payload = receivedAction.payload;
    if (payload != null) {
      var idPlan = payload['plan'];
      var idTask = payload['task'];
      if (idPlan != null && idTask != null) {
        var plan = dataModel.getPlan(int.parse(idPlan));
        if (plan != null) {
          var task = dataModel.getTask(plan, int.parse(idTask));
          if (task != null) {
            Task _task = task;
            _task.reminder = '(O.O)';
            _task.complete = true;
            _task.alert = false;
            dataModel.updateTask(plan, task);
            await writeData().then((value) {
              ToDoon.navigatorKey.currentState!.pushAndRemoveUntil<void>(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => TasksPage(plan: plan)),
                ModalRoute.withName('/'),
              );
            });
          }
        }
      }
    }
  }

  Future<void> onCompleteBackground(dynamic receivedAction) async {
    var payload = receivedAction.payload;
    if (payload != null) {
      loadData().then((value) async {
        var idPlan = payload['plan'];
        var idTask = payload['task'];
        if (idPlan != null && idTask != null) {
          var plan = dataModel.getPlan(int.parse(idPlan));
          if (plan != null) {
            var task = dataModel.getTask(plan, int.parse(idTask));
            if (task != null) {
              Task _task = task;
              _task.reminder = '(O.O)';
              _task.complete = true;
              _task.alert = false;
              dataModel.updateTask(plan, task);
              await writeData().then((value) {
                ToDoon.navigatorKey.currentState!.pushAndRemoveUntil<void>(
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => TasksPage(plan: plan)),
                  ModalRoute.withName('/'),
                );
              });
            }
          }
        }
      });
    }
  }

  ///Handle notice of a task.
  Future<void> onDisplayed(
      dynamic receivedNotification, NavigatorState currentState) async {
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
            _task.reminder = '(O.O)';
            _task.complete = task.complete;
            _task.alert = false;
            dataModel.updateTask(plan, _task);
            await writeData();
          }
        }
      }
    }
  }

  MaterialPageRoute onAppKilled(BuildContext context, dynamic receivedAction) {
    var payload = receivedAction.payload;
    if (payload != null) {
      var idPlan = payload['plan'];
      var idTask = payload['task'];
      if (idPlan != null && idTask != null) {
        var plan = dataModel.getPlan(int.parse(idPlan));
        if (plan != null) {
          var task = dataModel.getTask(plan, int.parse(idTask));
          if (task != null) {
            Task _task = task;
            _task.reminder = '(O.O)';
            _task.complete = task.complete;
            _task.alert = false;
            dataModel.updateTask(plan, _task);
            writeData();
            return MaterialPageRoute(builder: (_) => TasksPage(plan: plan));
          }
        }
      }
    }
    return MaterialPageRoute(builder: (_) => const PlansPage());
  }

  /// Format Iso8601 to String by current location.
  // ignore: non_constant_identifier_names
  String Iso8601toString(String? formattedString) {
    if (formattedString!.isNotEmpty && formattedString != "(O.O)") {
      DateTime datetime = DateTime.parse(formattedString);
      initializeDateFormatting(Language.instance.current.code, null);

      return DateFormat.yMd(Language.instance.current.code)
          .add_jms()
          .format(datetime);
    }

    return "(O.O)";
  }

  /// Format String to Iso8601 by current location..
  // ignore: non_constant_identifier_names
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

    return "(O.O)";
  }

  /// Format DateTime to String by current location.
  // ignore: non_constant_identifier_names
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

    return "(O.O)";
  }

  // ignore: non_constant_identifier_names
  DateTime? Iso8601toDateTime(String? formattedString) {
    if (formattedString!.isNotEmpty && formattedString != "(O.O)") {
      DateTime datetime = DateTime.parse(formattedString);
      return datetime;
    }

    return null;
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}
