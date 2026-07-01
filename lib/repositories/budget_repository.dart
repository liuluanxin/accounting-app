import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/budget.dart';

class BudgetRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<Budget?> getByMonth(String month) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      Tables.budgets,
      where: '${Tables.bgtMonth} = ? AND ${Tables.bgtCategoryId} IS NULL',
      whereArgs: [month],
    );
    if (maps.isEmpty) return null;
    return _fromDbMap(maps.first);
  }

  Future<void> upsert(Budget budget) async {
    final db = await _dbHelper.database;
    final existing = await getByMonth(budget.month);
    if (existing != null) {
      await db.update(
        Tables.budgets,
        _toDbMap(budget),
        where: '${Tables.bgtId} = ?',
        whereArgs: [existing.id],
      );
    } else {
      await db.insert(Tables.budgets, _toDbMap(budget));
    }
  }

  Budget _fromDbMap(Map<String, dynamic> map) {
    return Budget(
      id: map[Tables.bgtId] as String,
      month: map[Tables.bgtMonth] as String,
      totalAmount: (map[Tables.bgtTotal] as num).toDouble(),
      categoryId: map[Tables.bgtCategoryId] as String?,
      amount: (map[Tables.bgtAmount] as num).toDouble(),
    );
  }

  Map<String, dynamic> _toDbMap(Budget budget) {
    return {
      Tables.bgtId: budget.id,
      Tables.bgtMonth: budget.month,
      Tables.bgtTotal: budget.totalAmount,
      Tables.bgtCategoryId: budget.categoryId,
      Tables.bgtAmount: budget.amount,
    };
  }
}
