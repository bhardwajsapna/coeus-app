import 'package:flutter/material.dart';

class Constants {
  // Name
  static String appName = "Rhinestone";

  // Material Design Color
  static Color lightPrimary = Color(0xFFFFDAC1);
  static Color lightAccent = Color(0xFFFFDAC1);
  static Color lightBackground = Color(0xFFFFDAC1);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xFF3B72FF);
  static Color darkBackground = Colors.black;

  static Color grey = Color(0xff707070);
  static Color textPrimary = Color(0xFF486581);
  static Color textDark = Color(0xFF102A43);

  static Color backgroundColor = Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = Color(0xFF3ABD6F);
  static Color lightGreen = Color(0xFFE2F0CB);

  // Yellow
  static Color darkYellow = Color(0xFF3ABD6F);
  static Color lightYellow = Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = Color(0xFF60A3D9);
  static Color lightBlue = Color(0xFFACE7FF);

  // Orange
  static Color darkOrange = Color(0xFFFFB74D);
  static Color transparent = Color(0x00FFB700);
  static Color white = Color(0xFFFFFFFF);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: lightBackground,
      primaryColor: lightPrimary,
      accentColor: lightAccent,
      cursorColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,
      //textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        //textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        iconTheme: IconThemeData(
          color: lightAccent,
        ),
      ),
    );
  }

  static double headerHeight = 228.5;
  static double paddingSide = 10.0;
}