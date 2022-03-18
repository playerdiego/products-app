import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:products_app/providers/login_form_provider.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/theme/app_theme.dart';
import 'package:products_app/ui/input_login_decoration.dart';
import 'package:products_app/widgets/login_container.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginContainer(
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 250),
                const _Card(),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'register');
                  },
                  child: const Text('Create a new account',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 200),
              ],
            )),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 17,
            sigmaY: 17,
          ),
          child: Container(
            width: double.infinity,
            color: Colors.black54,
            child: ChangeNotifierProvider(
              create: (_) => LoginFormProvider(),
              child: const _LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginFormProvider loginFormProvider =
        Provider.of<LoginFormProvider>(context);

    return Container(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: loginFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Text('Login',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              initialValue: loginFormProvider.email,
              onChanged: (value) => loginFormProvider.email = value,
              keyboardType: TextInputType.emailAddress,
              decoration: InputLoginDecoration.inputDecoration(
                  hintText: 'flutter@gmail.com',
                  labelText: 'Email',
                  icon: Icons.alternate_email_rounded),
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                if (value != null && regExp.hasMatch(value)) return null;

                return 'Invalid Email';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              initialValue: loginFormProvider.password,
              onChanged: (value) => loginFormProvider.password = value,
              decoration: InputLoginDecoration.inputDecoration(
                  hintText: '***', labelText: 'Password', icon: Icons.password),
              validator: (value) {
                if (value != null && value.length >= 6) return null;

                return 'Password must have 6 characters or more';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: loginFormProvider.isLoading
                  ? null
                  : () async {
                      final AuthProvider authProvider =
                          Provider.of<AuthProvider>(context, listen: false);

                      if (!loginFormProvider.isValidForm()) return;

                      loginFormProvider.isLoading = true;

                      final errorMessage = await authProvider.signIn(
                          loginFormProvider.email, loginFormProvider.password);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(
                            context, 'products_list');
                      }

                      loginFormProvider.isLoading = false;
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child:
                    Text(loginFormProvider.isLoading ? 'Loading...' : 'Login'),
              ),
              color: loginFormProvider.isLoading
                  ? Colors.grey
                  : AppTheme.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
