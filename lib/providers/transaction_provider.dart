import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/account_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _txRepo = TransactionRepository();
  final CategoryRepository _catRepo = CategoryRepository();
  final AccountRepository _accRepo = AccountRepository();

  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _currentMonth;
  double _monthlyIncome = 0;
  double _monthlyExpense = 0;

  List<Transaction> get transactions => _transactions;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get currentMonth => _currentMonth;
  double get monthlyIncome => _monthlyIncome;
  double get monthlyExpense => _monthlyExpense;
  double get monthlyBalance => _monthlyIncome - _monthlyExpense;

  Future<void> loadTransactions({String? month}) async {
    _isLoading = true;
    _currentMonth = month;
    notifyListeners();
    try {
      _transactions = await _txRepo.getAll(month: month);
      if (month != null) {
        _monthlyIncome = await _txRepo.getTotalByMonth(month, 'income');
        _monthlyExpense = await _txRepo.getTotalByMonth(month, 'expense');
      }
    } catch (e) {
      debugPrint('TransactionProvider.loadTransactions error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _catRepo.getAll();
      notifyListeners();
    } catch (e) {
      debugPrint('TransactionProvider.loadCategories error: $e');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _txRepo.insert(transaction);
    await _updateAccountBalance(transaction);
    await loadTransactions(month: _currentMonth);
  }

  Future<void> deleteTransaction(String id) async {
    await _txRepo.delete(id);
    await loadTransactions(month: _currentMonth);
  }

  Future<void> _updateAccountBalance(Transaction tx) async {
    final account = await _accRepo.getById(tx.accountId);
    if (account != null) {
      final delta = tx.type == TransactionType.income ? tx.amount : -tx.amount;
      await _accRepo.updateBalance(tx.accountId, account.balance + delta);
    }
  }

  Map<String, List<Transaction>> get groupedByDate {
    final map = <String, List<Transaction>>{};
    for (final tx in _transactions) {
      final key = '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}-${tx.date.day.toString().padLeft(2, '0')}';
      map.putIfAbsent(key, () => []);
      map[key]!.add(tx);
    }
    return map;
  }
}
