// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/notifications/notifications_controller.dart';
import 'package:todoon/src/utils/ads_helper.dart';
import 'package:window_manager/window_manager.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/settings/settings_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/views/ToDoon.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inital windows.
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions =
        const WindowOptions(minimumSize: Size(800, 600));
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setTitle(Strings.NAME_APP);
    });
  }

  // Inital Ads.
  await AdsHelper.initialize();

  //  Inital Settings
  await SettingsController.initialize();

  // Inital Language.
  final languageData = SettingsController.instance.languageData;
  await Language.initialize(language: languageData);

  // Inital Theme.
  final themeMode = SettingsController.instance.themeMode;
  final colorMode = SettingsController.instance.colorMode;
  await Themes.initialize(themeMode: themeMode, colorMode: colorMode);

  // Inital Notifications.
  NotificationsController.initializeLocalNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsController.instance,
        ),
        ChangeNotifierProvider(
          create: (context) => Language.instance,
        ),
        ChangeNotifierProvider(
          create: (context) => Themes.instance,
        ),
        ChangeNotifierProvider(
          create: (context) => DataController.instance,
        ),
      ],
      child: Builder(
        builder: (context) => ToDoon(),
      ),
    ),
  );
}
