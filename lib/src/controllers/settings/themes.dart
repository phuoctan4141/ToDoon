// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todoon/src/constants/azure.dart';
import 'package:todoon/src/constants/bleed.dart';

enum ColorMode { azure, bleed }

/// Provides the [Theme] shown inside the UI.
class Themes extends AzureVisual with ChangeNotifier {
  /// [Theme] object singleton instance.
  static final Themes instance = Themes();

  /// Currently selected & displayed [ThemeMode].
  late ThemeMode current;
  late ColorMode color;

  /// Currently [ThemeMode] by [SystemTheme].
  late bool isLightMode = true;

  /// Light Theme.
  late ThemeData lightTheme;

  /// Dark Theme.
  late ThemeData darkTheme;

  // Must be called before [runApp].
  static Future<void> initialize(
          {required ThemeMode themeMode, required ColorMode colorMode}) =>
      instance.set(colorMode: colorMode, themeMode: themeMode);

  /// Updates the [current] themeMode & notifies the listeners.
  Future<void> set(
      {required ThemeMode themeMode, required ColorMode colorMode}) async {
    // Set currently [ThemeMode]
    current = themeMode;
    color = colorMode;
    await update();
    await updateColor();
    notifyListeners();
  }

  /// check and update isLightMode.
  Future<void> update() async {
    if (current == ThemeMode.light) {
      isLightMode = true;
    } else if (current == ThemeMode.dark) {
      isLightMode = false;
    } else {
      final brightness =
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .platformBrightness;
      isLightMode = (brightness == Brightness.light ? true : false);
    }

    notifyListeners();
  }

  /// check and update isLightMode.
  // ignore: no_leading_underscores_for_local_identifiers
  Future<void> updateColor() async {
    if (color.index == 0) {
      /// Light Theme.
      lightTheme = ThemeData(
        useMaterial3: false,
        colorScheme: AzureVisual.lightColorScheme,
        checkboxTheme: AzureVisual.checkboxThemeData,
      );

      /// Dark Theme.
      darkTheme = ThemeData(
        useMaterial3: false,
        colorScheme: AzureVisual.darkColorScheme,
        checkboxTheme: AzureVisual.checkboxThemeData,
      );
    } else {
      if (color.index == 1) {
        /// Light Theme.
        lightTheme = ThemeData(
          useMaterial3: true,
          colorScheme: BleedVisual.lightColorScheme,
          checkboxTheme: BleedVisual.checkboxThemeData,
        );

        /// Dark Theme.
        darkTheme = ThemeData(
          useMaterial3: true,
          colorScheme: BleedVisual.darkColorScheme,
          checkboxTheme: BleedVisual.checkboxThemeData,
        );
      }
    }

    notifyListeners();
  }

  // Radio Visuals
  Color get RadioSelectedColor {
    return isLightMode
        ? lightTheme.colorScheme.secondary
        : darkTheme.colorScheme.secondary;
  }
  // Radio Visuals

  // Dismissible Visuals
  Color get DismissibleBackgroundColor {
    return isLightMode
        ? lightTheme.colorScheme.errorContainer
        : darkTheme.colorScheme.errorContainer;
  }

  Color get DismissibleBackgroundItemColor {
    return isLightMode
        ? lightTheme.colorScheme.onErrorContainer
        : darkTheme.colorScheme.onErrorContainer;
  }

  ButtonStyle get DismissButtonStyle {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(DismissibleBackgroundColor),
      foregroundColor:
          MaterialStateProperty.all(DismissibleBackgroundItemColor),
    );
  }
  // Dismissible Visuals

  //Tasks Visuals
  Color TaskSectionCompleteColor(bool complete) {
    if (isLightMode) {
      return complete
          ? lightTheme.colorScheme.tertiary
          : lightTheme.colorScheme.surfaceVariant;
    } else {
      return complete
          ? darkTheme.colorScheme.tertiary
          : darkTheme.colorScheme.surfaceVariant;
    }
  }

  Color TaskItemCompleteColor(bool complete) {
    if (isLightMode) {
      return complete
          ? lightTheme.colorScheme.onTertiary
          : lightTheme.colorScheme.onSurfaceVariant;
    } else {
      return complete
          ? darkTheme.colorScheme.onTertiary
          : darkTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color TaskITemOutlinedColor(bool complete) {
    if (isLightMode) {
      return complete
          ? lightTheme.colorScheme.outlineVariant
          : lightTheme.colorScheme.outline;
    } else {
      return complete
          ? darkTheme.colorScheme.outlineVariant
          : darkTheme.colorScheme.outline;
    }
  }

  TextStyle TaskDescriptionTextStyle(bool complete) {
    return TextStyle(
      color: TaskItemCompleteColor(complete),
      decoration: complete ? TextDecoration.lineThrough : TextDecoration.none,
    );
  }
  //Tasks Visuals

  //Add Button Visuals
  ButtonStyle get AddButtonStyle {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(isLightMode
          ? lightTheme.colorScheme.secondary
          : darkTheme.colorScheme.secondary),
      foregroundColor: MaterialStateProperty.all(isLightMode
          ? lightTheme.colorScheme.onSecondary
          : darkTheme.colorScheme.onSecondary),
    );
  }
  //Add Button Visuals

  //Datetime Picker Visuals
  DatePickerTheme get DatetimePickerTheme {
    return DatePickerTheme(
      titleHeight: 48,
      itemStyle: TextStyle(
        color: isLightMode
            ? lightTheme.colorScheme.onBackground
            : darkTheme.colorScheme.onBackground,
        fontSize: 18,
      ),
      cancelStyle: TextStyle(
        color: isLightMode
            ? lightTheme.colorScheme.onBackground
            : darkTheme.colorScheme.onBackground,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      doneStyle: TextStyle(
        color: isLightMode
            ? lightTheme.colorScheme.secondary
            : darkTheme.colorScheme.secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: isLightMode
          ? lightTheme.colorScheme.background
          : darkTheme.colorScheme.background,
    );
  }
  //Datetime Picker Visuals

  //Switch Widget Visuals
  Color switchSectionColor(bool value) {
    if (isLightMode) {
      return value
          ? lightTheme.colorScheme.secondary
          : lightTheme.colorScheme.surfaceVariant;
    } else {
      return value
          ? darkTheme.colorScheme.secondary
          : darkTheme.colorScheme.surfaceVariant;
    }
  }

  Color get switchActiveItemColor {
    return isLightMode
        ? lightTheme.colorScheme.onSecondary
        : darkTheme.colorScheme.onSecondary;
  }

  Color get switchRollItemColor {
    return isLightMode
        ? lightTheme.colorScheme.inversePrimary
        : darkTheme.colorScheme.inversePrimary;
  }

  Color get switchInactiveItemColor {
    return isLightMode
        ? lightTheme.colorScheme.onSurfaceVariant
        : darkTheme.colorScheme.onSurfaceVariant;
  }

  get switchRollBorder {
    if (color.index == 0) {
      return AzureVisual.swtichRollBorder;
    } else if (color.index == 1) {
      return BleedVisual.swtichRollBorder;
    }
  }
  //Switch Widget Visuals

  // Drawer Visuals
  get DrawerTitleContentTextStyle {
    return TextStyle(fontWeight: FontWeight.bold, color: RadioSelectedColor);
  }

  get DrawerIconColor {
    return isLightMode
        ? lightTheme.colorScheme.onSurfaceVariant
        : darkTheme.colorScheme.onSurface;
  }

  Color DrawerItemCompleteContentColor(bool complete) {
    if (isLightMode) {
      return complete
          ? lightTheme.colorScheme.tertiary
          : lightTheme.colorScheme.onSurfaceVariant;
    } else {
      return complete
          ? darkTheme.colorScheme.tertiary
          : darkTheme.colorScheme.onSurfaceVariant;
    }
  }

  TextStyle DrawerItemContentTextStyle(bool complete) {
    return TextStyle(
      overflow: TextOverflow.ellipsis,
      color: DrawerItemCompleteContentColor(complete),
    );
  }
  // Drawer Visuals

  @override
  // ignore: must_call_super
  void dispose() {}
}
