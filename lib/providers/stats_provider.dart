import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/category_repository.dart';

class StatsProvider extends ChangeNotifier {
  final TransactionRepository _txRepo = TransactionRepository();
  final CategoryRepository _catRepo = CategoryRepository();

  String _activeTab = 'expense';
  String _currentMonth = '';
  double _totalIncome = 0;
  double _totalExpense = 0;
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  bool _isLoading = false;

  String get activeTab => _activeTab;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;
  bool get isLoading => _isLoading;

  void setActiveTab(String tab) {
    _activeTab = tab;
    notifyListeners();
  }

  Future<void> loadMonth(String month) async {
    _currentMonth = month;
    _isLoading = true;
    notifyListeners();
    try {
      _transactions = await _txRepo.getAll(month: month);
      _totalIncome = await _txRepo.getTotalByMonth(month, 'income');
      _totalExpense = await _txRepo.getTotalByMonth(month, 'expense');
      _categories = await _catRepo.getAll();
    } catch (e) {
      debugPrint('StatsProvider.loadMonth error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, double> get categoryTotals {
    final map = <String, double>{};
    final type = _activeTab == 'expense'
        ? TransactionType.expense
        : TransactionType.income;
    for (final tx in _transactions) {
      if (tx.type == type) {
        map[tx.categoryId] = (map[tx.categoryId] ?? 0) + tx.amount;
      }
    }
    return map;
  }

  List<_CategoryRank> get categoryRanks {
    final totals = categoryTotals;
    final totalAmount = totals.values.fold(0.0, (a, b) => a + b);
    final list = <_CategoryRank>[];
    for (final entry in totals.entries) {
      final cat = _categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => Category(id: '', name: '未知', type: 'expense'),
      );
      list.add(_CategoryRank(
        category: cat,
        amount: entry.value,
        percent: totalAmount > 0 ? entry.value / totalAmount : 0,
      ));
    }
    list.sort((a, b) => b.amount.compareTo(a.amount));
    return list;
  }
}

class _CategoryRank {
  final Category category;
  final double amount;
  final double percent;
  _CategoryRank({
    required this.category,
    required this.amount,
    required this.percent,
  });
}
