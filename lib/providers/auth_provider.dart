import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (user != null) {
        _loadUserProfile(user.id).then((_) => notifyListeners());
      } else {
        _currentUser = null;
        _activeRole = UserRole.buyer;
        notifyListeners();
      }
    });
  }
  UserModel? _currentUser;
  UserRole _activeRole = UserRole.buyer;
  String? _error;
  bool _isLoading = false;

  final _client = Supabase.instance.client;

  UserModel? get currentUser => _currentUser;
  UserRole   get activeRole  => _activeRole;
  bool       get isLoggedIn  => _currentUser != null;
  bool       get isSeller    => _activeRole == UserRole.seller;
  String?    get error       => _error;
  bool       get isLoading   => _isLoading;

  // ── Login ────────────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (res.user == null) {
        _error = 'Login failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _loadUserProfile(res.user!.id);
      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
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

    try {
      final res = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'name': name.trim(),
          'role': role.name,
        },
      );

      if (res.user == null) {
        _error = 'Registration failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _client.from('users').upsert({
        'id': res.user!.id,
        'name': name.trim(),
        'role': role.name,
        'avatar_url': '',
        'farm_name': farmName,
        'produce_type': produceType,
        'province': province ?? 'Phnom Penh',
      });

      await _loadUserProfile(res.user!.id);
      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Load profile from public.users ───────────────────────────────────────
  Future<void> _loadUserProfile(String userId) async {
    final data = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    final role = data['role'] == 'seller' ? UserRole.seller : UserRole.buyer;

    _currentUser = UserModel(
      id:            userId,
      name:          data['name'] ?? '',
      email:         _client.auth.currentUser?.email ?? '',
      phone:         data['phone'] ?? '',
      location:      data['province'] ?? 'Phnom Penh',
      role:          role,
      avatarInitial: (data['name'] ?? 'U')[0].toUpperCase(),
      farmName:      data['farm_name'],
      produceType:   data['produce_type'],
      province:      data['province'],
      isOrganic:     false,
    );

    _activeRole = role;
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await _client.auth.signOut();
    _currentUser = null;
    _activeRole = UserRole.buyer;
    _error = null;
    notifyListeners();
  }

  // ── Restore session on app launch ────────────────────────────────────────
  Future<void> restoreSession() async {
    try {
      final user = _client.auth.currentUser;
      if (user != null) {
        await _loadUserProfile(user.id);
        notifyListeners();
      }
    } catch (e) {
      // session restore failed silently
    }
  }

  // ── Switch role ──────────────────────────────────────────────────────────
  void switchRole(UserRole role) {
    _activeRole = role;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}