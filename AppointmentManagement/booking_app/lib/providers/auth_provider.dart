import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.unknown;
  User? _user;

  AuthStatus get status => _status;
  User? get user => _user;

  AuthProvider() {
    _authService.authState.listen((user) {
      _user = user;

      if (user == null) {
        _status = AuthStatus.unauthenticated;
      } else {
        _status = AuthStatus.authenticated;
      }

      notifyListeners();
    });
  }

  // =========================
  // GOOGLE LOGIN FLOW
  // =========================
  Future<Map<String, dynamic>?> signInWithGoogle() async {

    final user =
    await _authService.signInWithGoogle();

    if (user != null) {

      final result =
      await ApiService.saveGoogleUser(user);

      return result;
    }

    return null;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}





