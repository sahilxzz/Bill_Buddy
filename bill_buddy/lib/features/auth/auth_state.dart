import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;

  String? _token;
  String? _userId;
  String? _name;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;

  String? get token => _token;
  String? get userId => _userId;
  String? get name => _name;
  String? get email => _email;

  void login({
    required String token,
    required String userId,
    required String name,
    required String email,
  }) {
    _isLoggedIn = true;

    _token = token;
    _userId = userId;
    _name = name;
    _email = email;

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;

    _token = null;
    _userId = null;
    _name = null;
    _email = null;

    notifyListeners();
  }
}