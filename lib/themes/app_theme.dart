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

    appBarTheme: AppBarTheme(
      surfaceTintColor: whiteColor,
      color: whiteColor,
      iconTheme: const IconThemeData(color: blackColor),
      titleTextStyle: headingDisplay,
      centerTitle: true,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor.withValues(alpha: 0.5),
      selectionHandleColor: primaryColor,
    ),

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: whiteColor,
      secondary: whiteColor,
      onSecondary: primaryColor,
      surface: whiteColor,
      onSurface: textBodyColor,
      error: redColor,
    ),

    // Define default FloatingActionButton Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: whiteColor,
      elevation: 4.0,
      shape: CircleBorder(),
    ),

    // Define default Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor; // Color of the switch thumb when ON
        }
        return null; // Uses default color for OFF state
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withValues(
            alpha: 0.5,
          ); // Color of the track when ON
        }
        return null; // Uses default for OFF state
      }),
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
      filled: false,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
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
