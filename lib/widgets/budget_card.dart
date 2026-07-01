import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../utils/number_utils.dart';

class BudgetCard extends StatelessWidget {
  final double totalAmount;
  final double usedAmount;
  final List<_BudgetCategory> categories;

  const BudgetCard({
    super.key,
    required this.totalAmount,
    required this.usedAmount,
    this.categories = const [],
  });

  @override
  Widget build(BuildContext context) {
    final percent = totalAmount > 0 ? usedAmount / totalAmount : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: AppTheme.budgetCardDecoration,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          const Positioned(
            right: 12,
            top: 12,
            child: Text('📊 📈 📉',
                style: TextStyle(fontSize: 14),
                textDirection: TextDirection.ltr),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pie_chart, size: 14, color: AppTheme.textMain),
                      SizedBox(width: 6),
                      Text('本月预算',
                          style: TextStyle(fontSize: 14, color: AppTheme.textMain)),
                    ],
                  ),
                  Text(
                    NumberUtils.formatYuan(totalAmount),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percent.clamp(0.0, 1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.income, AppTheme.primary],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '已用 ${NumberUtils.formatYuan(usedAmount)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMain,
                    ),
                  ),
                  Text(
                    '剩余 ${NumberUtils.formatYuan((totalAmount - usedAmount).clamp(0, totalAmount))}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMain,
                    ),
                  ),
                ],
              ),
              if (categories.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: categories
                      .map((c) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${c.icon} ${c.name} ¥${c.usedAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textMain,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BudgetCategory {
  final String icon;
  final String name;
  final double usedAmount;
  _BudgetCategory({
    required this.icon,
    required this.name,
    required this.usedAmount,
  });
}
