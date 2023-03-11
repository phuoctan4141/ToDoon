import 'package:flutter/material.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

class EmptyIconWidget extends StatelessWidget {
  const EmptyIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      const AssetImage("assets/icons/todoon_border_256.ico"),
      size: 128,
      color: Themes.instance.isLightMode
          ? Themes.instance.lightTheme.colorScheme.onBackground
          : Themes.instance.darkTheme.colorScheme.onBackground,
    );
  }
}
