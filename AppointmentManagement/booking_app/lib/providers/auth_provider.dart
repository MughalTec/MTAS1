import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.unknown;
  ProviderModel? _provider;
  bool _isLoading = false;

  AuthStatus get status => _status;
  ProviderModel? get provider => _provider;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(user) async {
    if (user == null) {
      _status = AuthStatus.unauthenticated;
      _provider = null;
      notifyListeners();
    } else {
      try {
        final provider = await _authService.getProviderById(user.uid);
        _provider = provider;
        _status = AuthStatus.authenticated;
      } catch (_) {
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _provider = await _authService.signIn(email: email, password: password);
      _status = AuthStatus.authenticated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String businessCategory,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _provider = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        businessCategory: businessCategory,
      );
      _status = AuthStatus.authenticated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _provider = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void updateProvider(ProviderModel updated) {
    _provider = updated;
    notifyListeners();
  }
}
