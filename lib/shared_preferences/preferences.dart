import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static late SharedPreferences _prefs;

  static bool _darkMode = true;
  static Color _primaryColor = Colors.blue;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get darkMode {
    return _prefs.getBool('dark_mode') ?? _darkMode;
  }

  static set darkMode(bool value) {
    _darkMode = value;
    _prefs.setBool('dark_mode', value);
  }

}