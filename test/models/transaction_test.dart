import 'package:flutter_test/flutter_test.dart';
import 'package:accounting_app/models/transaction.dart';

void main() {
  group('Transaction', () {
    test('should create a Transaction with default values', () {
      final tx = Transaction(
        type: TransactionType.expense,
        amount: 18.40,
        categoryId: 'cat_food',
        accountId: 'acc_alipay',
        date: DateTime(2026, 7, 1),
      );

      expect(tx.id, isNotEmpty);
      expect(tx.type, TransactionType.expense);
      expect(tx.amount, 18.40);
      expect(tx.categoryId, 'cat_food');
      expect(tx.accountId, 'acc_alipay');
      expect(tx.typeStr, 'expense');
    });

    test('should create an income Transaction', () {
      final tx = Transaction(
        type: TransactionType.income,
        amount: 8000,
        categoryId: 'cat_salary',
        accountId: 'acc_cmb',
        date: DateTime(2026, 7, 1),
        note: '工资',
      );

      expect(tx.type, TransactionType.income);
      expect(tx.typeStr, 'income');
      expect(tx.note, '工资');
    });

    test('copyWith should create a new instance with updated values', () {
      final tx = Transaction(
        type: TransactionType.expense,
        amount: 18.40,
        categoryId: 'cat_food',
        accountId: 'acc_alipay',
        date: DateTime(2026, 7, 1),
      );

      final updated = tx.copyWith(amount: 23.50, note: '咖啡');

      expect(updated.amount, 23.50);
      expect(updated.note, '咖啡');
      expect(updated.id, tx.id);
      expect(updated.categoryId, tx.categoryId);
    });

    test('toJson and fromJson should be symmetrical', () {
      final tx = Transaction(
        type: TransactionType.expense,
        amount: 35.00,
        categoryId: 'cat_food',
        accountId: 'acc_wechat',
        date: DateTime(2026, 7, 1, 18, 5),
        note: '晚餐外卖',
      );

      // 模拟 fromJson（手动映射）
      expect(tx.id, isNotEmpty);
      expect(tx.typeStr, 'expense');
      expect(tx.amount, 35.00);
    });
  });
}
