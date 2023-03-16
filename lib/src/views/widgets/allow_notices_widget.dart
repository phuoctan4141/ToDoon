// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

Future<bool> AllowNoticesWidget(BuildContext context) async {
  if (Platform.isAndroid) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(Language.instance.Allow_Notifications),
            content: Text(Language.instance.Allow_Content),
            actionsPadding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 120,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.notifications_off),
                  label: Text(Language.instance.Dont_Allow),
                ),
              ),
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
                  icon: const Icon(Icons.notifications_on),
                  label: Text(Language.instance.Allow),
                  style: Themes.instance.AddButtonStyle,
                ),
              ),
            ],
          ),
        );
      }
    });

    return await AwesomeNotifications().isNotificationAllowed();
  } else {
    return false;
  }
}
