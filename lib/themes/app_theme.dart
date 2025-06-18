import 'package:flutter/material.dart';

// Import your new theme files
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,

    // Use colors from colors.dart
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: whiteColor,
      secondary: secondaryColor,
      onSecondary: primaryColor,
      background: backgroundColor,
      onBackground: textBodyColor,
      surface: whiteColor,
      onSurface: textBodyColor,
      error: redColor,
    ),

    // Use TextStyles from text_styles.dart
    textTheme: const TextTheme(
      displaySmall: headingDisplay, // For "Selamat Datang!"
      titleMedium: headingSection, // For "SDN 227 Margahayu Utara"
      bodyMedium: bodyRegular, // For paragraph text
      labelLarge: buttonPrimary, // For ElevatedButton text
    ),

    // Define default ElevatedButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: buttonPrimary,
      ),
    ),

    // Define default InputDecoration Theme for TextFields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: secondaryColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      labelStyle: inputLabel,
    ),

    // Define default TextButton Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: buttonText,
      ),
    ),
  );
}
