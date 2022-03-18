import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/theme/app_theme.dart';
import 'package:products_app/ui/input_login_decoration.dart';
import 'package:products_app/widgets/login_container.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  child: const Text('I already have an account',
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
              create: (_) => RegisterFormProvider(),
              child: const _RegisterForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterFormProvider registerFormProvider =
        Provider.of<RegisterFormProvider>(context);

    return Container(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: registerFormProvider.formKey,
        child: Column(
          children: [
            const Text('Create a new account',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              initialValue: registerFormProvider.email,
              onChanged: (value) => registerFormProvider.email = value,
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
              initialValue: registerFormProvider.password,
              onChanged: (value) => registerFormProvider.password = value,
              decoration: InputLoginDecoration.inputDecoration(
                  hintText: '***', labelText: 'Password', icon: Icons.password),
              validator: (value) {
                if (value != null && value.length >= 6) return null;

                return 'Password must have 6 characters or more';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: registerFormProvider.password,
              onChanged: (value) => registerFormProvider.repeatPassword = value,
              decoration: InputLoginDecoration.inputDecoration(
                  hintText: '***',
                  labelText: 'Repeat Password',
                  icon: Icons.password),
              validator: (value) {
                if (value != registerFormProvider.password) return 'Passwords dont match';

                return null;
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: registerFormProvider.isLoading
                  ? null
                  : () async {
                      final AuthProvider authProvider =
                          Provider.of<AuthProvider>(context, listen: false);

                      if (!registerFormProvider.isValidForm()) return;

                      registerFormProvider.isLoading = true;

                      final String? errorMessage =
                          await authProvider.createUser(
                              registerFormProvider.email,
                              registerFormProvider.password);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(
                            context, 'products_list');
                      }

                      registerFormProvider.isLoading = false;
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Text(registerFormProvider.isLoading
                    ? 'Loading...'
                    : 'Create account'),
              ),
              color: registerFormProvider.isLoading
                  ? Colors.grey
                  : AppTheme.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
