import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/tables.dart';
import '../models/account.dart';

class AccountRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Account>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query(Tables.accounts);
    return maps.map(_fromDbMap).toList();
  }

  Future<Account?> getById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      Tables.accounts,
      where: '${Tables.accId} = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _fromDbMap(maps.first);
  }

  Future<double> getTotalBalance() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      "SELECT COALESCE(SUM(${Tables.accBalance}), 0) as total FROM ${Tables.accounts}",
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<void> insert(Account account) async {
    final db = await _dbHelper.database;
    await db.insert(Tables.accounts, _toDbMap(account));
  }

  Future<void> updateBalance(String id, double newBalance) async {
    final db = await _dbHelper.database;
    await db.update(
      Tables.accounts,
      {Tables.accBalance: newBalance},
      where: '${Tables.accId} = ?',
      whereArgs: [id],
    );
  }

  Account _fromDbMap(Map<String, dynamic> map) {
    return Account(
      id: map[Tables.accId] as String,
      name: map[Tables.accName] as String,
      icon: map[Tables.accIcon] as String?,
      balance: (map[Tables.accBalance] as num).toDouble(),
      description: map[Tables.accDesc] as String?,
      color: map[Tables.accColor] as String?,
    );
  }

  Map<String, dynamic> _toDbMap(Account account) {
    return {
      Tables.accId: account.id,
      Tables.accName: account.name,
      Tables.accIcon: account.icon,
      Tables.accBalance: account.balance,
      Tables.accDesc: account.description,
      Tables.accColor: account.color,
    };
  }
}
