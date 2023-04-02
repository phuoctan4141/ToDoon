// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/app/ToDoon.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/notifications/notifications_controller.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/settings_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inital Ads.
  //await AdsHelper.initialize();

  // Inital Notifications.
  await NotificationsController.initializeLocalNotifications();

  //  Inital Settings
  await SettingsController.initialize();

  // Inital Language.
  final languageData = SettingsController.instance.languageData;
  await Language.initialize(language: languageData);

  // Inital Theme.
  final themeMode = SettingsController.instance.themeMode;
  final colorMode = SettingsController.instance.colorMode;
  await Themes.initialize(themeMode: themeMode, colorMode: colorMode);

  // Inital Data.
  await DataController.initialize();

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
