// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/notifications/notifications_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/routes/routes_export.dart';

class ToDoon extends StatefulWidget {
  // The navigator key is necessary to navigate using static methods.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const ToDoon({super.key});

  @override
  State<ToDoon> createState() => _ToDoonState();
}

class _ToDoonState extends State<ToDoon> with WidgetsBindingObserver {
  get currentContext => ToDoon.navigatorKey.currentContext;
  get currentState => ToDoon.navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationsController.initializeNotificationsEventListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    context.read<Themes>().updateTheme();
    super.didChangePlatformBrightness();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState: $state');
  }

  // Build ToDoon application.
  @override
  Widget build(BuildContext context) {
    String initialRoute =
        NotificationsController.initialAction == null ? PAGE_HOME : PAGE_PLAN;
    initialRoute = DataController.isFirstTime ? PAGE_INTRO : initialRoute;

    return Consumer<Themes>(
      builder: (context, themes, child) {
        return Consumer<Language>(
          builder: (context, language, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: ToDoon.navigatorKey,
              title: Strings.NAME_APP,
              theme: themes.lightTheme,
              darkTheme: themes.darkTheme,
              themeMode: themes.current,
              routes: materialRoutes,
              initialRoute: initialRoute,
              onGenerateRoute: (settings) {
                if (settings.name == PAGE_PLAN) {
                  return onAppKilled(context);
                }
                return null;
              },
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
            );
          },
        );
      },
    );
  }

  MaterialPageRoute onAppKilled(BuildContext context) {
    var initialAction = NotificationsController.initialAction;

    if (initialAction != null) {
      return context.read<DataController>().onAppKilled(initialAction);
    } else {
      return MaterialPageRoute(builder: (_) => PlansPage());
    }
  }
// end code.
}
