// ignore_for_file: inference_failure_on_function_return_type

import 'package:flutter/material.dart';

/// Bleeding Heart Theme.
class BleedTheme {
  /// Custom border check box icon.
  static get checkboxThemeData => CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

  static get switchRollBorder => BorderRadius.circular(50);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB31D5F),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFD9E1),
    onPrimaryContainer: Color(0xFF3F001C),
    secondary: Color(0xFF006591),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFC9E6FF),
    onSecondaryContainer: Color(0xFF001E2F),
    tertiary: Color(0xFF8E437E),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD7F0),
    onTertiaryContainer: Color(0xFF3A0033),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFF8FDFF),
    onBackground: Color(0xFF001F25),
    surface: Color(0xFFF8FDFF),
    onSurface: Color(0xFF001F25),
    surfaceVariant: Color(0xFFF2DDE1),
    onSurfaceVariant: Color(0xFF514346),
    outline: Color(0xFF837376),
    onInverseSurface: Color(0xFFD6F6FF),
    inverseSurface: Color(0xFF00363F),
    inversePrimary: Color(0xFFFFB1C6),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFB31D5F),
    outlineVariant: Color(0xFFD6C2C5),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB1C6),
    onPrimary: Color(0xFF650030),
    primaryContainer: Color(0xFF8E0047),
    onPrimaryContainer: Color(0xFFFFD9E1),
    secondary: Color(0xFF89CEFF),
    onSecondary: Color(0xFF00344D),
    secondaryContainer: Color(0xFF004C6E),
    onSecondaryContainer: Color(0xFFC9E6FF),
    tertiary: Color(0xFFFFACE8),
    onTertiary: Color(0xFF57124D),
    tertiaryContainer: Color(0xFF722B65),
    onTertiaryContainer: Color(0xFFFFD7F0),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF001F25),
    onBackground: Color(0xFFA6EEFF),
    surface: Color(0xFF001F25),
    onSurface: Color(0xFFA6EEFF),
    surfaceVariant: Color(0xFF514346),
    onSurfaceVariant: Color(0xFFD6C2C5),
    outline: Color(0xFF9E8C90),
    onInverseSurface: Color(0xFF001F25),
    inverseSurface: Color(0xFFA6EEFF),
    inversePrimary: Color(0xFFB31D5F),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFFFB1C6),
    outlineVariant: Color(0xFF514346),
    scrim: Color(0xFF000000),
  );
}
