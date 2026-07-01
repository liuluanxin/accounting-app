import 'package:flutter/foundation.dart';
import '../models/budget.dart';
import '../repositories/budget_repository.dart';
import '../repositories/transaction_repository.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository _bgtRepo = BudgetRepository();
  final TransactionRepository _txRepo = TransactionRepository();

  Budget? _currentBudget;
  double _monthlyExpense = 0;
  bool _isLoading = false;

  Budget? get currentBudget => _currentBudget;
  double get monthlyExpense => _monthlyExpense;
  bool get isLoading => _isLoading;

  double get usedPercent {
    if (_currentBudget == null || _currentBudget!.totalAmount == 0) return 0;
    return _monthlyExpense / _currentBudget!.totalAmount;
  }

  double get remaining {
    if (_currentBudget == null) return 0;
    return _currentBudget!.totalAmount - _monthlyExpense;
  }

  Future<void> loadBudget(String month) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentBudget = await _bgtRepo.getByMonth(month);
      _monthlyExpense = await _txRepo.getTotalByMonth(month, 'expense');
    } catch (e) {
      debugPrint('BudgetProvider.loadBudget error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
