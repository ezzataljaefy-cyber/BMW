import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final Color _lightPrimaryColor = Colors.blue.shade600;
  static final Color _lightOnPrimaryColor = Colors.white;
  static final Color _lightSecondaryColor = Colors.amber.shade700;
  static final Color _lightBackgroundColor = Colors.grey.shade100;
  static final Color _lightTextColor = Colors.black;

  static final Color _darkPrimaryColor = Colors.blue.shade400;
  static final Color _darkOnPrimaryColor = Colors.black;
  static final Color _darkSecondaryColor = Colors.amber.shade600;
  static final Color _darkBackgroundColor = Colors.grey.shade900;
  static final Color _darkTextColor = Colors.white;


  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _lightBackgroundColor,
    appBarTheme: AppBarTheme(
      color: _lightPrimaryColor,
      iconTheme: IconThemeData(color: _lightOnPrimaryColor),
      titleTextStyle: TextStyle(color: _lightOnPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      onPrimary: _lightOnPrimaryColor,
      secondary: _lightSecondaryColor,
      background: _lightBackgroundColor,
      onBackground: _lightTextColor,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: _lightTextColor),
      bodyMedium: TextStyle(color: _lightTextColor.withOpacity(0.8)),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimaryColor,
        foregroundColor: _lightOnPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: AppBarTheme(
      color: _darkPrimaryColor,
      iconTheme: IconThemeData(color: _darkOnPrimaryColor),
       titleTextStyle: TextStyle(color: _darkOnPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      onPrimary: _darkOnPrimaryColor,
      secondary: _darkSecondaryColor,
      background: _darkBackgroundColor,
      onBackground: _darkTextColor,
    ),
     textTheme: TextTheme(
      bodyLarge: TextStyle(color: _darkTextColor),
      bodyMedium: TextStyle(color: _darkTextColor.withOpacity(0.8)),
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade800,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: _darkOnPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
