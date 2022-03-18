import 'package:flutter/material.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

class CheckingScreen extends StatelessWidget {
  const CheckingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authProvider.getToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

            if(!snapshot.hasData) {
              return const CircularProgressIndicator(color: AppTheme.primaryColor);
            }
            
            if(snapshot.data == '') {
              Future.microtask(() => {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionDuration: const Duration(seconds: 0)
                ))
              });
            } else {

              Future.microtask(() => {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const ProductsListScreen(),
                  transitionDuration: const Duration(seconds: 0)
                ))
              });

            }

            return Container();

          },
        ),
      ),
    );
  }
}
