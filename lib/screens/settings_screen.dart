import 'package:flutter/material.dart';
import 'package:products_app/providers/preferences_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
   
  const SettingsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
         child: Column(
           children: [
             const SizedBox(height: 50),
             const Text('Settings', style: TextStyle(
               color: Colors.white,
               fontWeight: FontWeight.bold,
               fontSize: 50
             )),
             const SizedBox(height: 50),
             SwitchListTile.adaptive(
               value: preferencesProvider.darkMode,
               title: const Text('Dark Mode'),
               onChanged: (value) {
                 preferencesProvider.setDarkMode(value);
               }
             )
           ],
         ),
      ),
    );
  }
}