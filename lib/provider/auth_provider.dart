import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../api_manager/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userID;
  final _authInstance = FirebaseAuth.instance;

  bool get isAuthenticated {
    return token != null;
  }

  String get userID {
    return _userID;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signIn({emailID: String, password: String}) async {
    AuthResult authResult;

    try {
      authResult = await _authInstance.signInWithEmailAndPassword(
        email: emailID,
        password: password,
      );

      if (authResult != null) {
        notifyListeners();
      }
    } catch (err) {
      throw HTTPException(errorMessage: 'Invalid credentials!');
    }
  }

  Future<void> signUp({emailID: String, password: String}) async {
    AuthResult authResult;

    try {
      authResult = await _authInstance.createUserWithEmailAndPassword(
        email: emailID,
        password: password,
      );

      if (authResult != null) {
        notifyListeners();
      }
    } catch (err) {
      throw HTTPException(errorMessage: err.toString());
    }
  }
}
