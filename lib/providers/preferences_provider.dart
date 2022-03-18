import 'package:flutter/material.dart';
import 'package:products_app/shared_preferences/preferences.dart';

class PreferencesProvider extends ChangeNotifier {

  bool darkMode = Preferences.darkMode;

  setDarkMode(bool value) {
    darkMode = value;
    Preferences.darkMode = value;
    notifyListeners();
  }

}