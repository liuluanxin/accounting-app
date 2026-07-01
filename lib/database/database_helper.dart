import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../config/constants.dart';
import 'tables.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    for (final sql in allCreateTables) {
      await db.execute(sql);
    }
    await _seedDefaultData(db);
  }

  Future<void> _seedDefaultData(Database db) async {
    // 插入默认账户
    await db.insert('accounts', {
      'id': 'acc_cmb',
      'name': '招商银行储蓄卡',
      'icon': 'credit-card',
      'balance': 8234.56,
      'description': '尾号 1234',
      'color': '0xFF6BA8D9',
    });
    await db.insert('accounts', {
      'id': 'acc_alipay',
      'name': '支付宝',
      'icon': 'alipay',
      'balance': 2456.78,
      'description': '余额宝',
      'color': '0xFF6BA8D9',
    });
    await db.insert('accounts', {
      'id': 'acc_wechat',
      'name': '微信零钱',
      'icon': 'weixin',
      'balance': 2156.00,
      'description': '理财通',
      'color': '0xFF7BC4A8',
    });
    await db.insert('accounts', {
      'id': 'acc_cash',
      'name': '现金',
      'icon': 'money-bill-wave',
      'balance': 500.00,
      'description': '钱包',
      'color': '0xFFE8B96E',
    });

    // 插入默认支出分类
    for (int i = 0; i < defaultExpenseCategories.length; i++) {
      final cat = defaultExpenseCategories[i];
      await db.insert('categories', {
        'id': cat['id'],
        'name': cat['name'],
        'icon': cat['icon'],
        'type': 'expense',
        'sort_order': i,
      });
    }

    // 插入默认收入分类
    for (int i = 0; i < defaultIncomeCategories.length; i++) {
      final cat = defaultIncomeCategories[i];
      await db.insert('categories', {
        'id': cat['id'],
        'name': cat['name'],
        'icon': cat['icon'],
        'type': 'income',
        'sort_order': i,
      });
    }

    // 插入默认用户
    await db.insert('users', {
      'id': 'user_default',
      'nickname': '张小明',
      'phone': '138****8888',
    });

    // 插入当月预算
    await db.insert('budgets', {
      'id': 'bgt_202607_total',
      'month': '2026-07',
      'total_amount': 1500.00,
      'category_id': null,
      'amount': 1500.00,
    });

    // 插入示例交易
    final now = DateTime.now();
    await db.insert('transactions', {
      'id': 'tx_001',
      'type': 'expense',
      'amount': 18.40,
      'category_id': 'cat_food',
      'account_id': 'acc_alipay',
      'date': DateTime(now.year, now.month, now.day, 14, 32).toIso8601String(),
      'note': null,
      'tags': null,
      'created_at': DateTime.now().toIso8601String(),
    });
    await db.insert('transactions', {
      'id': 'tx_002',
      'type': 'expense',
      'amount': 23.50,
      'category_id': 'cat_food',
      'account_id': 'acc_wechat',
      'date': DateTime(now.year, now.month, now.day, 10, 15).toIso8601String(),
      'note': null,
      'tags': null,
      'created_at': DateTime.now().toIso8601String(),
    });
    await db.insert('transactions', {
      'id': 'tx_003',
      'type': 'income',
      'amount': 8000.00,
      'category_id': 'cat_salary',
      'account_id': 'acc_cmb',
      'date': DateTime(now.year, now.month, now.day - 1, 20, 29).toIso8601String(),
      'note': '6月工资',
      'tags': null,
      'created_at': DateTime.now().toIso8601String(),
    });
    await db.insert('transactions', {
      'id': 'tx_004',
      'type': 'expense',
      'amount': 35.00,
      'category_id': 'cat_food',
      'account_id': 'acc_wechat',
      'date': DateTime(now.year, now.month, now.day - 1, 18, 5).toIso8601String(),
      'note': null,
      'tags': null,
      'created_at': DateTime.now().toIso8601String(),
    });
    await db.insert('transactions', {
      'id': 'tx_005',
      'type': 'expense',
      'amount': 6.00,
      'category_id': 'cat_transport',
      'account_id': 'acc_cmb',
      'date': DateTime(now.year, now.month, now.day - 1, 8, 30).toIso8601String(),
      'note': null,
      'tags': null,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
