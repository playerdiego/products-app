import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AuthProvider extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseKey = 'AIzaSyAUQLbFUWwnLv2hKxvIjPgcXqWhf1laRbE';

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final Uri url =
        Uri.https(_baseUrl, 'v1/accounts:signUp', {'key': _firebaseKey});

    final Response res = await post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(res.body);

    if (decodedData.containsKey('idToken')) {
      storage.write(key: 'token', value: decodedData['idToken']);
      return null;
    } else {
      return decodedData['error']['message'];
    }
  }

  Future<String?> signIn(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final Uri url = Uri.https(
        _baseUrl, 'v1/accounts:signInWithPassword', {'key': _firebaseKey});

    final Response res = await post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(res.body);

    if (decodedData.containsKey('idToken')) {
      storage.write(key: 'token', value: decodedData['idToken']);
      return null;
    } else {
      return decodedData['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  Future<String> getToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
