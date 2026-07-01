import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/category_repository.dart';

class CalendarProvider extends ChangeNotifier {
  final TransactionRepository _txRepo = TransactionRepository();
  final CategoryRepository _catRepo = CategoryRepository();

  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  bool _isLoading = false;

  DateTime get selectedDate => _selectedDate;
  DateTime get currentMonth => _currentMonth;
  List<Transaction> get transactions => _transactions;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  double get dayIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get dayExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get dayBalance => dayIncome - dayExpense;

  Future<void> loadMonth(DateTime month) async {
    _currentMonth = month;
    _isLoading = true;
    notifyListeners();
    try {
      final monthKey =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      _transactions = await _txRepo.getAll(month: monthKey);
      _categories = await _catRepo.getAll();
    } catch (e) {
      debugPrint('CalendarProvider.loadMonth error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    await loadDay(_selectedDate);
  }

  Future<void> loadDay(DateTime day) async {
    _selectedDate = day;
    notifyListeners();
  }

  Set<DateTime> get daysWithTransactions {
    final dates = <DateTime>{};
    for (final tx in _transactions) {
      dates.add(DateTime(tx.date.year, tx.date.month, tx.date.day));
    }
    return dates;
  }

  bool hasTransactionOnDay(DateTime day) {
    return daysWithTransactions.contains(day);
  }
}
