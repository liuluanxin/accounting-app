import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/stats_provider.dart';
import '../../widgets/donut_chart.dart';
import '../../utils/number_utils.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final month =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsProvider>().loadMonth(month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatsProvider>();
    final ranks = statsProvider.categoryRanks;
    final chartColors = [
      const Color(0xFFB5E8D5),
      const Color(0xFFA8D4E8),
      const Color(0xFFC5B8E8),
      const Color(0xFFFFD89E),
      const Color(0xFFE0F0EA),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部标题
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('📊', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('统计',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain)),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: AppTheme.textMain),
                    SizedBox(width: 16),
                    Icon(Icons.more_horiz, color: AppTheme.textMain),
                  ],
                ),
              ],
            ),
          ),
          // 切换
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFF0E8FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildToggle('支出', 'expense', statsProvider),
                  _buildToggle('收入', 'income', statsProvider),
                  _buildToggle('资产', 'asset', statsProvider),
                ],
              ),
            ),
          ),
          // 汇总卡片
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: AppTheme.frostedCardDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('月支出',
                    NumberUtils.formatYuan(statsProvider.totalExpense),
                    AppTheme.expense),
                _buildStatItem('月收入',
                    NumberUtils.formatYuan(statsProvider.totalIncome),
                    AppTheme.income),
                _buildStatItem(
                    '结余',
                    NumberUtils.formatYuan(statsProvider.balance),
                    AppTheme.primary),
              ],
            ),
          ),
          // 环形图
          if (statsProvider.activeTab != 'asset') ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.frostedCardDecoration,
              child: Column(
                children: [
                  DonutChart(
                    slices: ranks
                        .map((r) => _ChartSliceData(
                            value: r.amount,
                            color: chartColors[ranks.indexOf(r) % chartColors.length]))
                        .toList(),
                    size: 160,
                  ),
                  const SizedBox(height: 16),
                  // 图例
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: ranks.take(5).map((r) {
                      final idx = ranks.indexOf(r) % chartColors.length;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: chartColors[idx],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${r.category.icon ?? r.category.name} ${r.category.name} ${NumberUtils.formatPercent(r.percent)}',
                            style: const TextStyle(
                                fontSize: 13, color: AppTheme.textMain),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // 支出排名标题
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                statsProvider.activeTab == 'expense' ? '支出排名' : '收入排名',
                style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSub,
                    fontWeight: FontWeight.w500),
              ),
            ),
            // 排名列表
            ...ranks.take(5).toList().asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final item = entry.value;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text('$rank',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSub)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F0EA),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          item.category.icon ?? '📦',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item.category.name,
                          style: const TextStyle(fontSize: 14)),
                    ),
                    Container(
                      height: 8,
                      constraints: const BoxConstraints(maxWidth: 120),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0E8FA),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: item.percent.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: chartColors[rank - 1 % chartColors.length],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      NumberUtils.formatYuan(item.amount),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildToggle(String label, String tab, StatsProvider provider) {
    final isActive = provider.activeTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (tab == 'asset') return;
          provider.setActiveTab(tab);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? AppTheme.primary : AppTheme.textSub,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSub)),
        const SizedBox(height: 4),
        Text(amount,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _ChartSliceData {
  final double value;
  final Color color;
  _ChartSliceData({required this.value, required this.color});
}
