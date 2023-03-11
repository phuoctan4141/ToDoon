// ignore_for_file: file_names, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/notifications/notifications_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/views/data/plans/plans_page.dart';

class ToDoon extends StatefulWidget {
  // The navigator key is necessary to navigate using static methods.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const ToDoon({super.key});

  @override
  State<ToDoon> createState() => _ToDoonState();
}

class _ToDoonState extends State<ToDoon> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid) {
      final noticesController = context.read<NotificationsController>();
      noticesController.allowNotices(context);
      NotificationsController.startListeningNotificationEvents();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    Themes.instance.update().then((_) => setState(() {}));
    super.didChangePlatformBrightness();
  }

  // Build ToDoon application.
  @override
  Widget build(BuildContext context) {
    final themes = Provider.of<Themes>(context, listen: true);
    final language = Provider.of<Language>(context, listen: true);

    return MaterialApp(
      title: Strings.NAME_APP,
      theme: themes.lightTheme,
      darkTheme: themes.darkTheme,
      themeMode: themes.current,
      navigatorKey: ToDoon.navigatorKey,
      locale: Locale(language.current.code),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('vi'), // VietNam
      ],
      home: PlansPage(),
    );
  }
}
