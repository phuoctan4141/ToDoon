// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/models/data_model.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/utils/file_manager.dart';

/// Control Data application.
class DataController with ChangeNotifier {
  /// [Data] object singleton instance.
  static DataController instance = DataController();

  /// Data Handle Model.
  final dataModel = DataModel();

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

      state = await FileManager.instance.writeJsonFile(
          Strings.FOLDER_APP, Strings.DATA_FILE, dataModel.getDataStorage);
    }

    notifyListeners();
    return state;
  }

  /// load [data] to the dataModel.
  Future<void> loadData() async {
    final jsonResponse = await FileManager.instance
        .readJsonFile(Strings.FOLDER_APP, Strings.DATA_FILE);

    if (jsonResponse != null) {
      dataModel.setMemoryCache(PlansList.fromJson(jsonResponse));
      dataModel.setStorage(PlansList.fromJson(jsonResponse));
    }

    notifyListeners();
  }

  /// write [data] to storage.
  Future<void> writeData() async {
    await FileManager.instance.writeJsonFile(
        Strings.FOLDER_APP, Strings.DATA_FILE, dataModel.getDataStorage);

    notifyListeners();
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

  @override
  // ignore: must_call_super
  void dispose() {}
}
