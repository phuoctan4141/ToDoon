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
import 'package:todoon/src/routes/routes.dart';
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
  get currentContext => ToDoon.navigatorKey.currentContext;
  get currentState => ToDoon.navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationsController.initializeNotificationsEventListeners();
    fetandhandleData(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    context.read<Themes>().update();
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
    final themes = Provider.of<Themes>(context, listen: true);
    final language = Provider.of<Language>(context, listen: true);

    String initialRoute =
        NotificationsController.initialAction == null ? PAGE_HOME : PAGE_PLAN;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.NAME_APP,
      theme: themes.lightTheme,
      darkTheme: themes.darkTheme,
      themeMode: themes.current,
      navigatorKey: ToDoon.navigatorKey,
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
  }

  void fetandhandleData(BuildContext context) {
    context.read<DataController>().fetandcreateJsonFile().then((state) {
      if (state.compareTo(States.isEXIST) == 0) {
        context.read<DataController>().loadData();
      }
    });
  }

  MaterialPageRoute onAppKilled(BuildContext context) {
    var initialAction = NotificationsController.initialAction;

    if (initialAction != null) {
      return context.read<DataController>().onAppKilled(context, initialAction);
    } else {
      return MaterialPageRoute(builder: (_) => const PlansPage());
    }
  }
// end code.
}
