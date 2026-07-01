import 'package:intl/intl.dart';

class NumberUtils {
  NumberUtils._();

  static String formatAmount(double amount) {
    final formatter = NumberFormat('#,##0.00', 'zh_CN');
    return formatter.format(amount.abs());
  }

  static String formatAmountWithSign(double amount) {
    final absStr = formatAmount(amount);
    if (amount > 0) return '+$absStr';
    if (amount < 0) return '-$absStr';
    return absStr;
  }

  static String formatYuan(double amount) {
    return '¥${formatAmount(amount)}';
  }

  static String formatPercent(double percent) {
    return '${(percent * 100).toStringAsFixed(0)}%';
  }
}
