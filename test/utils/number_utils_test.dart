import 'package:flutter_test/flutter_test.dart';
import 'package:accounting_app/utils/number_utils.dart';

void main() {
  group('NumberUtils', () {
    test('formatAmount should format correctly', () {
      expect(NumberUtils.formatAmount(1234.5), '1,234.50');
      expect(NumberUtils.formatAmount(0), '0.00');
      expect(NumberUtils.formatAmount(100), '100.00');
    });

    test('formatYuan should add prefix', () {
      expect(NumberUtils.formatYuan(100), '¥100.00');
    });

    test('formatAmountWithSign should add sign', () {
      expect(NumberUtils.formatAmountWithSign(100), '+100.00');
      expect(NumberUtils.formatAmountWithSign(-50), '-50.00');
      expect(NumberUtils.formatAmountWithSign(0), '0.00');
    });
  });
}
