import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../repositories/account_repository.dart';

class AccountProvider extends ChangeNotifier {
  final AccountRepository _repo = AccountRepository();
  List<Account> _accounts = [];
  double _totalBalance = 0;
  bool _isLoading = false;

  List<Account> get accounts => _accounts;
  double get totalBalance => _totalBalance;
  bool get isLoading => _isLoading;

  Future<void> loadAccounts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _accounts = await _repo.getAll();
      _totalBalance = await _repo.getTotalBalance();
    } catch (e) {
      debugPrint('AccountProvider.loadAccounts error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
