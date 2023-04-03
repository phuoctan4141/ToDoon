import 'package:flutter/material.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

/// Empty Icon Widget.
class EmptyIconWidget extends StatelessWidget {
  const EmptyIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      const AssetImage(ToDoonIcons.todoon_outline_assets),
      size: 128,
      color: Themes.instance.isLightMode
          ? Themes.instance.lightTheme.colorScheme.onBackground
          : Themes.instance.darkTheme.colorScheme.onBackground,
    );
  }
}
