import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  UserRole _activeRole = UserRole.buyer;

  UserModel? get currentUser => _currentUser;
  UserRole get activeRole => _activeRole;
  bool get isLoggedIn => _currentUser != null;
  bool get isSeller => _activeRole == UserRole.seller;

  void setUser(UserModel user) {
    _currentUser = user;
    _activeRole = user.role;
    notifyListeners();
  }

  void switchRole(UserRole role) {
    _activeRole = role;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _activeRole = UserRole.buyer;
    notifyListeners();
  }
}