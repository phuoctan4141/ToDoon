// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
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

  /// Using the app for the first time.
  /// If [true] then show [IntroPage] screen.
  Future<void> get onFirstTime async {
    Language.instance.available.then((available) {
      late Locale _deviceLocale = window.locale;
      // Set lang for the _deviceLocale language.
      if (_deviceLocale.languageCode != Language.instance.current.locate) {
        if (_deviceLocale.languageCode == 'vi') {
          final value =
              available.firstWhere((element) => element.locate == 'vi');
          Language.instance.set(value: value);
        } else {
          final value =
              available.firstWhere((element) => element.locate == 'en');
          Language.instance.set(value: value);
        }
        // Save setting.
        saveSetting();
      }
    });
  }

  /// Create [settings.json] & notifies the listeners.
  Future<void> createSettingFile() async {
    String state = States.FALSE;

    state = await FileManager.instance
        .createJsonFile(States.FOLDER_APP, States.SETTINGS_FILE);

    if (state.compareTo(States.CREATED_FILE) == 0) {
      final jsonContent =
          await rootBundle.loadString('assets/data/settings.json');

      final jsonResponse = json.decode(jsonContent);

      await FileManager.instance
          .writeJsonFile(States.FOLDER_APP, States.SETTINGS_FILE, jsonResponse);
    }

    notifyListeners();
  }

  /// Load settings file & notifies the listeners.
  Future<void> loadSetting() async {
    final jsonResponse = await FileManager.instance
        .readJsonFile(States.FOLDER_APP, States.SETTINGS_FILE);

    if (jsonResponse != null) {
      languageData = LanguageData.fromJson(jsonResponse['language']);
      themeMode = ThemeMode.values[jsonResponse['themeMode']];
      colorMode = ColorMode.values[jsonResponse['colorMode']];
    }

    notifyListeners();
  }

  /// Save [current] settings to storage & notifies the listeners.
  Future<void> saveSetting() async {
    final jsonResponse = jsonDecode(settingJson);

    FileManager.instance
        .writeJsonFile(States.FOLDER_APP, States.SETTINGS_FILE, jsonResponse);

    notifyListeners();
  }

  /// Setting json string.
  String get settingJson => '{'
      '"language":${jsonEncode(languageData)},'
      '"themeMode": ${themeMode.index},'
      '"colorMode": ${colorMode.index}'
      '}';

  @override
  // ignore: must_call_super
  void dispose() {}
}
