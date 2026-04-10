import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  UserRole _activeRole = UserRole.buyer;
  String? _error;
  bool _isLoading = false;

  // Mock user "database" — in a real app this hits an API
  final List<UserModel> _registeredUsers = [];

  UserModel? get currentUser  => _currentUser;
  UserRole   get activeRole   => _activeRole;
  bool       get isLoggedIn   => _currentUser != null;
  bool       get isSeller     => _activeRole == UserRole.seller;
  String?    get error        => _error;
  bool       get isLoading    => _isLoading;

  // ── Login ────────────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.trim().isEmpty || password.isEmpty) {
      _error = 'Please fill in all fields.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Find user in registered list
    final found = _registeredUsers.where(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    ).toList();

    if (found.isEmpty) {
      _error = 'No account found with that email.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // In real app: verify hashed password. Here we just accept any password.
    _currentUser = found.first;
    _activeRole  = found.first.role;
    _isLoading   = false;
    notifyListeners();
    return true;
  }

  // ── Register ─────────────────────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? farmName,
    String? produceType,
    String? province,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      _error = 'Please fill in all required fields.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _error = 'Password must be at least 6 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Check duplicate email
    final exists = _registeredUsers.any(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );
    if (exists) {
      _error = 'An account with that email already exists.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = UserModel(
      id:            'u_${DateTime.now().millisecondsSinceEpoch}',
      name:          name.trim(),
      email:         email.trim().toLowerCase(),
      phone:         '',
      location:      province ?? 'Phnom Penh',
      role:          role,
      avatarInitial: name.trim()[0].toUpperCase(),
      farmName:      farmName,
      produceType:   produceType,
      province:      province,
      isOrganic:     false,
    );

    _registeredUsers.add(newUser);
    _currentUser = newUser;
    _activeRole  = role;
    _isLoading   = false;
    notifyListeners();
    return true;
  }

  // ── Seed demo accounts (called from mock_data) ───────────────────────────
  void seedUsers(List<UserModel> users) {
    _registeredUsers.addAll(users);
  }

  // ── Switch role ──────────────────────────────────────────────────────────
  void switchRole(UserRole role) {
    _activeRole = role;
    notifyListeners();
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  void logout() {
    _currentUser = null;
    _activeRole  = UserRole.buyer;
    _error       = null;
    notifyListeners();
  }

  void setUser(UserModel user) {
    _currentUser = user;
    _activeRole  = user.role;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}