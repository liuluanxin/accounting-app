import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../database/database_helper.dart';

class AuthProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  AppUser? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      final db = await _dbHelper.database;
      final maps = await db.query('users', limit: 1);
      if (maps.isNotEmpty) {
        _currentUser = AppUser.fromJson(maps.first);
        _isLoggedIn = true;
      }
    } catch (e) {
      debugPrint('AuthProvider.loadUser error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String phone, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = AppUser(
        nickname: '张小明',
        phone: phone,
      );
      _isLoggedIn = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
