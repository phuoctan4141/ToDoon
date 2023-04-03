import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';

/// Back Button Widget.
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.watch<Language>().Back,
      icon: const Icon(ToDoonIcons.back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
