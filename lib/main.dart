import 'dart:io';

import 'package:flutter/material.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/screens/settings_screen.dart';
import 'package:products_app/shared_preferences/preferences.dart';
import 'package:products_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();

  HttpOverrides.global = MyHttpOverrides();

  runApp(const AppState());

}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(context);
    final ProductsProvider productsProvider = Provider.of<ProductsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'checking',
      routes: {
        'checking': (_) => const CheckingScreen(),
        'products_list': (_) => const ProductsListScreen(),
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
        'settings': (_) => const SettingsScreen(),
        'edit_product': (_) => ChangeNotifierProvider(
          create: (_) => EditProductProvider(productsProvider.selectedProduct),
          child: const EditProductScreen(),
        )
      },
      theme: preferencesProvider.darkMode
        ? ThemeData.dark().copyWith(
          primaryColor: AppTheme.primaryColor
        ) : ThemeData.light().copyWith(
          primaryColor: AppTheme.primaryColor
        ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}