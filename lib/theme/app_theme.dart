import 'package:flutter/material.dart';

class AppTheme {
  
  static const Color primaryColor = Colors.purple;
  static const Color secondaryColor = Colors.teal;

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor
  );

  static final ThemeData lightTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor
  );

}