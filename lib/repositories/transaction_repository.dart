import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/transaction.dart';

class TransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Transaction>> getAll({String? month}) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> maps;

    if (month != null) {
      maps = await db.query(
        Tables.transactions,
        where: "strftime('%Y-%m', date) = ?",
        whereArgs: [month],
        orderBy: 'date DESC',
      );
    } else {
      maps = await db.query(
        Tables.transactions,
        orderBy: 'date DESC',
      );
    }

    return maps.map(_fromDbMap).toList();
  }

  Future<List<Transaction>> getByDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final maps = await db.query(
      Tables.transactions,
      where: "date(date) = date(?)",
      whereArgs: [dateStr],
      orderBy: 'date DESC',
    );
    return maps.map(_fromDbMap).toList();
  }

  Future<double> getTotalByMonth(String month, String type) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      "SELECT COALESCE(SUM(amount), 0) as total FROM ${Tables.transactions} "
      "WHERE strftime('%Y-%m', date) = ? AND type = ?",
      [month, type],
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<void> insert(Transaction transaction) async {
    final db = await _dbHelper.database;
    await db.insert(Tables.transactions, _toDbMap(transaction));
  }

  Future<void> update(Transaction transaction) async {
    final db = await _dbHelper.database;
    await db.update(
      Tables.transactions,
      _toDbMap(transaction),
      where: '${Tables.txId} = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      Tables.transactions,
      where: '${Tables.txId} = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _toDbMap(Transaction tx) {
    return {
      Tables.txId: tx.id,
      Tables.txType: tx.typeStr,
      Tables.txAmount: tx.amount,
      Tables.txCategoryId: tx.categoryId,
      Tables.txAccountId: tx.accountId,
      Tables.txDate: tx.date.toIso8601String(),
      Tables.txNote: tx.note,
      Tables.txTags: tx.tags,
      Tables.txCreatedAt: tx.createdAt.toIso8601String(),
    };
  }

  Transaction _fromDbMap(Map<String, dynamic> map) {
    return Transaction(
      id: map[Tables.txId] as String,
      type: map[Tables.txType] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      amount: (map[Tables.txAmount] as num).toDouble(),
      categoryId: map[Tables.txCategoryId] as String,
      accountId: map[Tables.txAccountId] as String,
      date: DateTime.parse(map[Tables.txDate] as String),
      note: map[Tables.txNote] as String?,
      tags: map[Tables.txTags] as String?,
      createdAt: DateTime.parse(map[Tables.txCreatedAt] as String),
    );
  }
}
