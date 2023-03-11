import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/utils/file_manager.dart';

/// Currently Setting data
abstract class SettingData {
  late LanguageData languageData;
  late ThemeMode themeMode;
  late ColorMode colorMode;
}

/// Control all application settings and configuration.
class SettingsController with SettingData, ChangeNotifier {
  /// [Settings] object singleton instance.
  static SettingsController instance = SettingsController();

  /// Initial [configuration] for the application.
  static Future<void> initialize() async {
    await instance.createSettingFile();
    await instance.loadSetting();
  }

  /// Create [settings.json] & notifies the listeners.
  Future<void> createSettingFile() async {
    String state = States.FALSE;

    state = await FileManager.instance
        .createJsonFile(Strings.FOLDER_APP, Strings.SETTINGS_FILE);

    if (state.compareTo(States.CREATED_FILE) == 0) {
      final jsonContent =
          await rootBundle.loadString('assets/data/settings.json');

      final jsonResponse = json.decode(jsonContent);

      await FileManager.instance.writeJsonFile(
          Strings.FOLDER_APP, Strings.SETTINGS_FILE, jsonResponse);
    }

    notifyListeners();
  }

  /// Load settings file & notifies the listeners.
  Future<void> loadSetting() async {
    final jsonResponse = await FileManager.instance
        .readJsonFile(Strings.FOLDER_APP, Strings.SETTINGS_FILE);

    if (jsonResponse != null) {
      languageData = LanguageData.fromJson(jsonResponse['language']);
      themeMode = ThemeMode.values[jsonResponse['themeMode']];
      colorMode = ColorMode.values[jsonResponse['colorMode']];
    }

    notifyListeners();
  }

  /// Save [current] settings to storage & notifies the listeners.
  Future<void> saveSetting() async {
    final jsonResponse = jsonDecode(
        '''{"language":${jsonEncode(languageData)},"themeMode": ${themeMode.index},"colorMode": ${colorMode.index}}''');

    FileManager.instance
        .writeJsonFile(Strings.FOLDER_APP, Strings.SETTINGS_FILE, jsonResponse);

    notifyListeners();
  }

  @override
  // ignore: must_call_super
  void dispose() {}
}
