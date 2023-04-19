// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

/// Allow Notifications Widget.
Future<bool> AllowNoticesWidget(BuildContext context) async {
  if (Platform.isAndroid) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            insetPadding: const EdgeInsets.all(8.0),
            actionsPadding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0),
            actionsAlignment: MainAxisAlignment.center,
            title: Text(Language.instance.Allow_Notifications),
            content: Text(Language.instance.Allow_Content),
            actions: [
              /// Dont Allow Button (Cancel).
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 120,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(ToDoonIcons.notifications_off),
                  label: Text(Language.instance.Dont_Allow),
                ),
              ),

              /// Allow Button (Confirm).
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 120,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications();
                  },
                  icon: Icon(ToDoonIcons.notifications_on),
                  label: Text(Language.instance.Allow),
                  style: Themes.instance.AddButtonStyle,
                ),
              ),
            ],
          ),
        );
      }
    });

    /// Return true if notification is allowed.
    return await AwesomeNotifications().isNotificationAllowed();
  } else {
    return false;
  }
}
