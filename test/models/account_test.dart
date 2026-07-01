import 'package:flutter_test/flutter_test.dart';
import 'package:accounting_app/models/account.dart';

void main() {
  group('Account', () {
    test('should create an Account with given values', () {
      final acc = Account(
        name: '招商银行储蓄卡',
        balance: 8234.56,
        icon: 'credit-card',
        description: '尾号 1234',
      );

      expect(acc.id, isNotEmpty);
      expect(acc.name, '招商银行储蓄卡');
      expect(acc.balance, 8234.56);
      expect(acc.icon, 'credit-card');
    });

    test('copyWith should update balance', () {
      final acc = Account(name: '支付宝', balance: 2000);
      final updated = acc.copyWith(balance: 2500);
      expect(updated.balance, 2500);
      expect(updated.name, '支付宝');
    });
  });
}
