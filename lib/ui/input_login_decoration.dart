import 'package:flutter/material.dart';
import 'package:products_app/theme/app_theme.dart';

class InputLoginDecoration {

  static InputDecoration inputDecoration ({
    Color color = AppTheme.primaryColor,
    required String hintText,
    required String labelText,
    required IconData icon,
  }) {
    return InputDecoration(

      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white)
      ),

      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 3, color: AppTheme.primaryColor)
      ),

      hintText: hintText,
      labelText: labelText,

      labelStyle: TextStyle(color: color),

      icon: Icon(icon, color: AppTheme.primaryColor)
    );
  }


}