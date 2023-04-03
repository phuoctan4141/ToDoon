import 'package:flutter/material.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/views/settings/settings_page.dart';

/// Settings Button Widget.
class SettingsButtonWidget extends StatelessWidget {
  const SettingsButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: Language.instance.Settings_Title,
      icon: const Icon(ToDoonIcons.settings),
      onPressed: () => Navigator.pushNamed(context, SettingsPage.routeName),
    );
  }
}
