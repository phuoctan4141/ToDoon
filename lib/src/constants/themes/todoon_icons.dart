// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

class ToDoonIcons {
  static const String banner_assets = 'assets/icons/banner.png';
  static const String todoon_filled_assets = 'assets/icons/todoon_256.ico';
  static const String todoon_outline_assets =
      'assets/icons/todoon_border_256.ico';
  static const String do_work_lottie = 'assets/icons/do_work.json';
  static const String language_lottie = 'assets/icons/language.json';
  static const String color_lottie = 'assets/icons/color.json';
  static const String today_lottie = 'assets/icons/today.json';
  static const String no_task_lottie = 'assets/icons/no_task.json';

  static const IconData home = Icons.home;
  static const IconData settings = Icons.settings;
  static const IconData drawer = Icons.menu;
  static const IconData back = Icons.arrow_back;
  static const IconData done = Icons.done_all_rounded;
  static const IconData add_plan = Icons.format_list_bulleted_add;
  static const IconData add_task = Icons.add_task;
  static const IconData edit = Icons.mode_edit_rounded;
  static const IconData edit_plan = Icons.drive_file_rename_outline_rounded;
  static const IconData edit_task = Icons.edit_note;
  static const IconData delete = Icons.delete_forever_rounded;
  static const IconData delete_sweep = Icons.delete_sweep_rounded;
  static const IconData cancel = Icons.cancel_sharp;
  static const IconData error = Icons.error_outline_sharp;
  static const IconData search = Icons.search_sharp;
  static const IconData refresh = Icons.replay;
  static const IconData notifications_off = Icons.notifications_off;
  static const IconData notifications_on = Icons.notifications_on;
  static const IconData plan = Icons.assignment_outlined;
  static const IconData task = Icons.receipt_long_rounded;
  static const IconData dueDate = Icons.event_available_outlined;
  static const IconData reminder = Icons.alarm_sharp;
  static const IconData add_reminder = Icons.alarm_add_sharp;

  // Alert icons for application (on and off).
  static IconData getAlertState(bool alert) =>
      alert ? Icons.alarm_on_sharp : Icons.alarm_off_sharp;

  // Theme icons for application (light and dark mode).
  static const ValueKey<String> light_mode_key = ValueKey('light_mode');
  static const ValueKey<String> dark_mode_key = ValueKey('dark_mode');
  static Icon getThemeState(bool isLight) => isLight
      ? const Icon(Icons.light_mode_rounded,
          color: Colors.amberAccent, key: light_mode_key)
      : const Icon(Icons.dark_mode_rounded,
          color: Colors.blueAccent, key: dark_mode_key);

  // Language icons for application (English and Vietnamese).
  static const ValueKey<String> english_key = ValueKey('english');
  static const ValueKey<String> vietnamese_key = ValueKey('vietnamese');
  static Icon getLanguageState(String language) => language == 'vi'
      ? const Icon(Icons.star_rounded,
          color: Colors.amberAccent, key: vietnamese_key)
      : const Icon(Icons.public_rounded,
          color: Colors.blueAccent, key: english_key);

  // Color icons for application (Azure and Pink).
  static const ValueKey<String> azure_key = ValueKey('azure');
  static const ValueKey<String> bleed_key = ValueKey('bleed');
  static Icon getColorState(ColorMode colorMode) => colorMode == ColorMode.azure
      ? const Icon(Icons.local_florist_rounded,
          color: Colors.blueAccent, key: azure_key)
      : const Icon(Icons.spa_rounded, color: Colors.pinkAccent, key: bleed_key);
}
