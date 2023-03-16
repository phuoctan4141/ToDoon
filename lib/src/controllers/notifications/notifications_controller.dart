// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, unused_field

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/ToDoon.dart';
import 'package:todoon/src/views/widgets/allow_notices_widget.dart';

class NotificationsController with ChangeNotifier {
  static final NotificationsController instance = NotificationsController();
  bool _initialized = false;

  static ReceivedAction? initialAction;

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'ToDoon',
              channelDescription: 'ToDoon',
              locked: true,
              playSound: true,
              channelShowBadge: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Public,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional.
    await interceptInitialActionRequest();

    ReceivePort port = ReceivePort();
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      'background_notification_action',
    );

    port.listen((var received) async {
      _handleBackgroundAction(received);
    });

    instance._initialized = true;
  }

  /// Initialize Notifications Event Listeners.
  static Future<void> initializeNotificationsEventListeners() async {
    if (Platform.isAndroid) {
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: instance.onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: instance.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      );
    }
  }

  /// Use this method to detect when a new notification or a schedule is created.
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed.
  @pragma("vm:entry-point")
  Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    onDisplayed(receivedNotification);
  }

  /// Use this method to detect if the user dismissed a notification.
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button.
  @pragma("vm:entry-point")
  Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized.
    WidgetsFlutterBinding.ensureInitialized();

    var life = await AwesomeNotifications().getAppLifeCycle();
    switch (life) {
      case NotificationLifeCycle.Foreground:
        {
          var currentState = ToDoon.navigatorKey.currentState;
          if (currentState != null) {
            // ignore: use_build_context_synchronously
            var data = Provider.of<DataController>(currentState.context,
                listen: false);

            data.onComplete(receivedAction);
          }
        }
        break;
      case NotificationLifeCycle.Background:
        {
          onSilentActionHandle(receivedAction);
        }
        break;
      default:
        {}
        break;
    }

    // Your code goes here
  }

  static Future<void> onSilentActionHandle(ReceivedAction received) async {
    print('On new background action received: ${received.toMap()}');

    if (!instance._initialized) {
      SendPort? uiSendPort =
          IsolateNameServer.lookupPortByName('background_notification_action');
      if (uiSendPort != null) {
        print(
            'Background action running on parallel isolate without valid context. Redirecting execution');
        uiSendPort.send(received);
        return;
      }
    }

    print('Background action running on main isolate');
    await _handleBackgroundAction(received);
  }

  static Future<void> _handleBackgroundAction(ReceivedAction received) async {
    // Your background action handle
    DataController.instance.onCompleteBackground(received);
  }

  Future<void> onComplete(ReceivedAction receivedAction) async {}

  static Future<void> onDisplayed(
      ReceivedNotification receivedNotification) async {
    var currentState = ToDoon.navigatorKey.currentState;

    if (currentState != null) {
      currentState.context
          .read<DataController>()
          .onDisplayed(receivedNotification, currentState);
    }
  }

  /// Create a task reminder notice.
  static Future<void> createTaskReminderNotification(
      Plan plan, Task task, DateTime date) async {
    // Always ensure that all plugins was initialized.
    WidgetsFlutterBinding.ensureInitialized();

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AllowNoticesWidget(ToDoon.navigatorKey.currentContext!);
    }
    if (!isAllowed) return;

    Map<String, String> payload = {
      'plan': plan.id.toString(),
      'task': task.id.toString(),
    };

    late Locale _deviceLocale = window.locale;
    late String _completeLabel = Language.instance.Complete;
    late String _cancelLabel = Language.instance.Cancel;
    // Set label for the _deviceLocale language.
    if (_deviceLocale.languageCode != Language.instance.current.locate) {
      if (_deviceLocale.languageCode == 'vi') {
        _completeLabel = 'Hoàn thành';
        _cancelLabel = 'Hủy';
      } else {
        _completeLabel = 'Complete';
        _cancelLabel = 'Cancel';
      }
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: task.id,
        channelKey: 'alerts',
        title: '${Emojis.animals_octopus} ${plan.name}',
        body: task.description,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        payload: payload,
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'COMPLETE',
            label: _completeLabel,
            actionType: ActionType.SilentAction),
      ],
      schedule: NotificationCalendar.fromDate(date: date),
    );
  }

  static Future<void> cancelAllSchedulesNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> cancelScheduledNotificationsById(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  static dismissNotificationsById(int id) async {
    await AwesomeNotifications().dismiss(id);
  }

  static Future<void> interceptInitialActionRequest() async {
    ReceivedAction? receivedAction =
        await AwesomeNotifications().getInitialNotificationAction();

    if (receivedAction?.channelKey == 'alerts') {
      initialAction = receivedAction;
    }
  }
}
