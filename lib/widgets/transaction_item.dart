import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class TransactionItem extends StatelessWidget {
  final String iconText;
  final bool isExpense;
  final String title;
  final String meta;
  final String amount;
  final String method;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.iconText,
    required this.isExpense,
    required this.title,
    required this.meta,
    required this.amount,
    required this.method,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isExpense
        ? const Color(0xFFE0F0EA)
        : const Color(0xFFF0E8E8);
    final iconColor = isExpense ? AppTheme.expense : AppTheme.income;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB4A0C8).withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  iconText,
                  style: TextStyle(fontSize: 18, color: iconColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(meta,
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textSub)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isExpense ? AppTheme.expense : AppTheme.income,
                  ),
                ),
                const SizedBox(height: 2),
                Text(method,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textSub)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
