// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, unused_import

import 'dart:io';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/models/plan/plan_export.dart';

// Control Notifications.
class NotificationsController with ChangeNotifier {
  /// [Notifications] object singleton instance.
  static final NotificationsController instance = NotificationsController();

  /// ReceivedAction for the notice.
  static ReceivedAction? initialCallAction;

  /// Initial [Notifications] for the application.
  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'scheduled_channel',
            channelName: 'ToDoon',
            channelDescription: 'ToDoon',
            defaultColor: Colors.teal,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          ),
        ],
      );
      // Get initial notification action is optional
      initialCallAction =
          await AwesomeNotifications().getInitialNotificationAction();
    }
  }

  ///  Notifications events are only delivered after call this method.
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  /// Use this method to detect when the user [taps] on a notification or action button.
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == "COMPLETE") {
      instance.onComplete(receivedAction.payload);
    }
  }

  /// Create a task schedule notice.
  Future<void> createTaskReminderNotification(Plan plan, Task task) async {
    print('create notices');
    // Always ensure that all plugins was initialized.
    WidgetsFlutterBinding.ensureInitialized();

    // Create a payload.
    final Map<String, String> payload = {
      'plan': plan.id.toString(),
      'task': task.id.toString()
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

    // Create a scheduled notification.
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: task.id,
        channelKey: 'scheduled_channel',
        title: plan.name,
        body: task.description,
        notificationLayout: NotificationLayout.Default,
        payload: payload,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'COMPLETE',
          label: _completeLabel,
          actionType: ActionType.SilentBackgroundAction,
        ),
        NotificationActionButton(
            key: 'CANCEL',
            label: _cancelLabel,
            actionType: ActionType.DismissAction,
            isDangerousOption: true),
      ],
      schedule: NotificationCalendar(
        second: 1,
        millisecond: 0,
        repeats: false,
      ),
    );

    notifyListeners();
  }

  Future<void> onComplete(Map<String, String?>? payload) async {
    final Map<String, String?> _payload = payload!;

    if (_payload.isEmpty) return;

    final DataController dataController = DataController.instance;
    late Plan? _plan =
        dataController.dataModel.getPlan(_payload['plan'] as int);
    late Task? _task =
        dataController.dataModel.getTask(_plan!, _payload['task'] as int);

    print(_task);

    notifyListeners();
  }

  Future<void> cancelTaskNotifications(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
    notifyListeners();
  }

  Future<void> allowNotices(BuildContext context) async {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(Language.instance.Allow),
              content: Text(Language.instance.Allow_Content),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    Language.instance.Dont_Allow,
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    Language.instance.Allow,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
