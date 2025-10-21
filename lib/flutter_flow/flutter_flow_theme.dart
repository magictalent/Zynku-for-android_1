import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    TextStyle? font,
  }) {
    return copyWith(
      fontFamily: fontFamily,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }
}

class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) => FlutterFlowTheme();

  Color get primaryBackground => Colors.white;
  Color get secondaryBackground => Colors.grey.shade200;
  Color get primaryText => Colors.black;
  Color get primary => Colors.blue;
  Color get error => Colors.red;
  Color get secondary => Colors.grey;
  Color get tertiary => Colors.orange;
  Color get alternate => Colors.green;
  Color get accent1 => Colors.purple;
  Color get warning => Colors.amber;
  Color get success => Colors.green;
  Color get secondaryText => Colors.grey.shade600;

  TextStyle get displayMedium => const TextStyle(fontSize: 24);
  TextStyle get displaySmall => const TextStyle(fontSize: 16);
  TextStyle get titleSmall => const TextStyle(fontSize: 14);
  TextStyle get titleMedium => const TextStyle(fontSize: 18);
  TextStyle get titleLarge => const TextStyle(fontSize: 22);
  TextStyle get headlineLarge => const TextStyle(fontSize: 32);
  TextStyle get headlineMedium => const TextStyle(fontSize: 28);
  TextStyle get headlineSmall => const TextStyle(fontSize: 24);
  TextStyle get bodyLarge => const TextStyle(fontSize: 16);
  TextStyle get bodyMedium => const TextStyle(fontSize: 14);
  TextStyle get labelMedium => const TextStyle(fontSize: 12);
  TextStyle get labelLarge => const TextStyle(fontSize: 14);

  FlutterFlowTheme();
}
