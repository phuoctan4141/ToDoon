// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, unused_field

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/app/ToDoon.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/widgets/allow_notices_widget.dart';

/// Notifications Controller.
class NotificationsController {
  /// [Notifications] object singleton instance.
  static final NotificationsController instance = NotificationsController();

  /// [Notifications] object private constructor.
  bool _initialized = false;
  static ReceivedAction? initialAction;

  /// Initialize Notifications.
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: States.NOTICE_CHANNEL,
              channelName: Strings.NAME_APP,
              channelDescription: Strings.NAME_APP,
              locked: true,
              playSound: true,
              //channelShowBadge: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Public,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: false);

    // Get initial notification action is optional.
    await interceptInitialActionRequest();

    ReceivePort port = ReceivePort();
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      States.NOTICE_BACKGROUND,
    );

    port.listen((dynamic received) async {
      _handleBackgroundAction(received);
    });

    instance._initialized = true;
  }

  /// Initialize Notifications Event Listeners.
  static Future<void> initializeNotificationsEventListeners() async {
    if (Platform.isAndroid) {
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
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
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    var currentState = ToDoon.navigatorKey.currentState;

    if (currentState != null) {
      currentState.context
          .read<DataController>()
          .onDisplayed(receivedNotification, currentState);
    }
  }

  /// Use this method to detect if the user dismissed a notification.
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    DataController.instance.onDismiss(receivedAction);
  }

  /// Use this method to detect when the user taps on a notification or action button.
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized.
    WidgetsFlutterBinding.ensureInitialized();

    // Your code goes here
    final life = await AwesomeNotifications().getAppLifeCycle();
    switch (life) {
      case NotificationLifeCycle.Foreground:
        {
          var currentState = ToDoon.navigatorKey.currentState;
          if (currentState != null) {
            if (currentState.mounted) {
              currentState.context
                  .read<DataController>()
                  .onComplete(receivedAction);
            }
          }
        }
        break;
      case NotificationLifeCycle.Background:
        {
          onSilentActionHandle(receivedAction);
        }
        break;
      default:
        {
          onSilentActionHandle(receivedAction);
        }
        break;
    }
  }

  /// Silent action handle.
  static Future<void> onSilentActionHandle(ReceivedAction received) async {
    print('On new background action received: ${received.actionDate}');

    if (!instance._initialized) {
      SendPort? uiSendPort =
          IsolateNameServer.lookupPortByName(States.NOTICE_BACKGROUND);
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

  /// Background handle for action.
  static Future<void> _handleBackgroundAction(ReceivedAction received) async {
    // Your background action handle
    DataController.instance.onCompleteBackground(received);
  }

  /// Create a task reminder notice.
  static Future<String> createTaskReminderNotification(
      Plan plan, Task task, DateTime date) async {
    // Always ensure that all plugins was initialized.
    WidgetsFlutterBinding.ensureInitialized();

    // Cancel a notification created.
    cancelScheduledNotificationsById(task.id);
    // Dismiss a notification displayed.
    dismissNotificationsById(task.id);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AllowNoticesWidget(ToDoon.navigatorKey.currentContext!);
    }
    if (!isAllowed) return States.FALSE;

    // Set a payload.
    Map<String, String> payload = {
      'plan': plan.id.toString(),
      'task': task.id.toString(),
      'deadline': States.FALSE,
    };
    // Set action label.
    final mapLabel = Language.instance.getNoticeLabel;
    late String _completeLabel = mapLabel['COMPLETE']!;
    late String _cancelLabel = mapLabel['CANCEL']!;

    // Create a notification.
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: task.id,
        channelKey: States.NOTICE_CHANNEL,
        title: '${Emojis.animals_octopus} ${plan.name}',
        body: task.description,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        payload: payload,
      ),
      actionButtons: [
        NotificationActionButton(
            key: States.NOTICE_COMPLETE,
            label: _completeLabel,
            actionType: ActionType.Default),
        ////////////////////////////////////
        NotificationActionButton(
            key: States.NOTICE_CANCEL,
            label: _cancelLabel,
            actionType: ActionType.DismissAction),
      ],
      schedule: NotificationCalendar.fromDate(date: date),
    );

    return States.TRUE;
  }

  /// Create a task deadline notice.
  static Future<void> createTaskDeadlineNotification(
      Plan plan, Task task, DateTime date) async {
    // Always ensure that all plugins was initialized.
    WidgetsFlutterBinding.ensureInitialized();
    // Set a unique id.
    int id = plan.id + task.id;
    // Cancel a notification created.
    cancelScheduledNotificationsById(id);
    // Dismiss a notification displayed.
    dismissNotificationsById(id);

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AllowNoticesWidget(ToDoon.navigatorKey.currentContext!);
    }
    if (!isAllowed) return;

    // Set a payload.
    Map<String, String> payload = {
      'plan': plan.id.toString(),
      'task': task.id.toString(),
      'deadline': States.TRUE,
    };
    // Set action label.
    final mapLabel = Language.instance.getNoticeLabel;
    late String _completeLabel = mapLabel['COMPLETE']!;
    late String _cancelLabel = mapLabel['CANCEL']!;

    // Create a notification.
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: States.NOTICE_CHANNEL,
        title: '${Emojis.food_bubble_tea} ${plan.name}',
        body: task.description,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        payload: payload,
      ),
      actionButtons: [
        NotificationActionButton(
            key: States.NOTICE_COMPLETE,
            label: _completeLabel,
            actionType: ActionType.Default),
        ////////////////////////////////////
        NotificationActionButton(
            key: States.NOTICE_CANCEL,
            label: _cancelLabel,
            actionType: ActionType.DismissAction),
      ],
      schedule: NotificationCalendar.fromDate(date: date),
    );
  }

  /// Cancel all scheduled notifications.
  static Future<void> cancelAllSchedulesNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  /// Cancel scheduled notifications by id.
  static Future<void> cancelScheduledNotificationsById(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  /// Dismiss notifications by id.
  static dismissNotificationsById(int id) async {
    await AwesomeNotifications().dismiss(id);
  }

  /// Get intercept initial notification action is optional.
  static Future<void> interceptInitialActionRequest() async {
    ReceivedAction? receivedAction =
        await AwesomeNotifications().getInitialNotificationAction();

    if (receivedAction?.channelKey == States.NOTICE_CHANNEL) {
      initialAction = receivedAction;
    }
  }
}
