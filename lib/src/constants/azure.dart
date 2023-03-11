import 'package:flutter/material.dart';

/// Azure Visual
class AzureVisual {
  /// Custom border check box icon.
  static get checkboxThemeData => CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      );

  static get swtichRollBorder => BorderRadius.circular(5);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0061A3),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD1E4FF),
    onPrimaryContainer: Color(0xFF001D36),
    secondary: Color(0xFF7B5900),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDEA4),
    onSecondaryContainer: Color(0xFF261900),
    tertiary: Color(0xFF006874),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF97F0FF),
    onTertiaryContainer: Color(0xFF001F24),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFDFBFF),
    onBackground: Color(0xFF001B3D),
    surface: Color(0xFFFDFBFF),
    onSurface: Color(0xFF001B3D),
    surfaceVariant: Color(0xFFDFE2EB),
    onSurfaceVariant: Color(0xFF42474E),
    outline: Color(0xFF73777F),
    onInverseSurface: Color(0xFFECF0FF),
    inverseSurface: Color(0xFF003062),
    inversePrimary: Color(0xFF9ECAFF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF0061A3),
    outlineVariant: Color(0xFFC3C7CF),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9ECAFF),
    onPrimary: Color(0xFF003258),
    primaryContainer: Color(0xFF00497D),
    onPrimaryContainer: Color(0xFFD1E4FF),
    secondary: Color(0xFFF5BE48),
    onSecondary: Color(0xFF412D00),
    secondaryContainer: Color(0xFF5D4200),
    onSecondaryContainer: Color(0xFFFFDEA4),
    tertiary: Color(0xFF4FD8EB),
    onTertiary: Color(0xFF00363D),
    tertiaryContainer: Color(0xFF004F58),
    onTertiaryContainer: Color(0xFF97F0FF),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF001B3D),
    onBackground: Color(0xFFD6E3FF),
    surface: Color(0xFF001B3D),
    onSurface: Color(0xFFD6E3FF),
    surfaceVariant: Color(0xFF42474E),
    onSurfaceVariant: Color(0xFFC3C7CF),
    outline: Color(0xFF8D9199),
    onInverseSurface: Color(0xFF001B3D),
    inverseSurface: Color(0xFFD6E3FF),
    inversePrimary: Color(0xFF0061A3),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF9ECAFF),
    outlineVariant: Color(0xFF42474E),
    scrim: Color(0xFF000000),
  );
}
