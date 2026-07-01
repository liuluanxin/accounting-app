import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/calendar_provider.dart';
import '../../widgets/transaction_item.dart';
import '../../utils/date_utils.dart';
import '../../utils/number_utils.dart';
import '../record/record_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarProvider>().loadMonth(_currentMonth);
    });
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    context.read<CalendarProvider>().loadMonth(_currentMonth);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    context.read<CalendarProvider>().loadMonth(_currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    final calProvider = context.watch<CalendarProvider>();
    final dayTxs = calProvider.transactions
        .where((t) =>
            t.date.year == _selectedDay.year &&
            t.date.month == _selectedDay.month &&
            t.date.day == _selectedDay.day)
        .toList();

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
                    Text('📅', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Text('日历',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain)),
                  ],
                ),
                const Icon(Icons.more_horiz, color: AppTheme.textMain),
              ],
            ),
          ),
          // 月份导航
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      DateUtils.formatMonth(_currentMonth),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.textMain),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _prevMonth,
                      child: const Icon(Icons.chevron_left,
                          size: 16, color: AppTheme.textSub),
                    ),
                    GestureDetector(
                      onTap: _nextMonth,
                      child: const Icon(Icons.chevron_right,
                          size: 16, color: AppTheme.textSub),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F0FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0D4F0)),
                  ),
                  child: const Row(
                    children: [
                      Text('月',
                          style: TextStyle(
                              fontSize: 13, color: AppTheme.textSub)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 12, color: AppTheme.textSub),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 日历网格
          _buildCalendar(),
          const SizedBox(height: 8),
          // 当天汇总
          _buildDaySummary(calProvider),
          const SizedBox(height: 8),
          // 当天账单标题
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Text('📋 当天账单',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSub,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          // 当天账单列表
          ...dayTxs.map((tx) => TransactionItem(
                iconText: _getCatIcon(tx.categoryId),
                isExpense: tx.type.name == 'expense',
                title: tx.note ?? '记账',
                meta:
                    '${DateUtils.formatTime(tx.date)} · ${_getCatName(tx.categoryId)}',
                amount:
                    '${tx.type.name == 'expense' ? '-' : '+'}${NumberUtils.formatAmount(tx.amount)}',
                method: _getAccName(tx.accountId),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RecordPage()),
                  );
                },
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final daysInMonth = DateUtils.daysInMonth(_currentMonth);
    final firstWeekday = DateUtils.firstWeekday(_currentMonth);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 星期标题
          Row(
            children: ['日', '一', '二', '三', '四', '五', '六'].map((d) {
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(d,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSub,
                          fontWeight: FontWeight.w500)),
                ),
              );
            }).toList(),
          ),
          // 日期网格
          ...List.generate((daysInMonth + firstWeekday + 6) ~/ 7, (row) {
            return Row(
              children: List.generate(7, (col) {
                final day = row * 7 + col - firstWeekday + 1;
                if (day < 1 || day > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 40));
                }
                final date = DateTime(
                    _currentMonth.year, _currentMonth.month, day);
                final isToday = date == today;
                final isSelected = date == _selectedDay;
                final calProvider = context.read<CalendarProvider>();
                final hasTx = calProvider.hasTransactionOnDay(date);

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedDay = date);
                      calProvider.loadDay(date);
                    },
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : isToday
                                      ? AppTheme.primary
                                      : AppTheme.textMain,
                            ),
                          ),
                          if (hasTx)
                            Positioned(
                              bottom: 4,
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.expense,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDaySummary(CalendarProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FC),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB4A0C8).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('收入', NumberUtils.formatYuan(provider.dayIncome),
              AppTheme.income),
          _buildSummaryItem('支出', NumberUtils.formatYuan(provider.dayExpense),
              AppTheme.expense),
          _buildSummaryItem(
              '净额', NumberUtils.formatYuan(provider.dayBalance), AppTheme.textMain),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSub)),
        const SizedBox(height: 4),
        Text(amount,
            style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  String _getCatIcon(String id) {
    const icons = {
      'cat_food': '🍱',
      'cat_transport': '🚇',
      'cat_shopping': '🛒',
      'cat_entertain': '🎬',
      'cat_housing': '🏠',
      'cat_medical': '💊',
      'cat_education': '📚',
      'cat_salary': '💼',
      'cat_other': '📦',
    };
    return icons[id] ?? '📦';
  }

  String _getCatName(String id) {
    const names = {
      'cat_food': '餐饮',
      'cat_transport': '交通',
      'cat_shopping': '购物',
      'cat_entertain': '娱乐',
      'cat_housing': '居住',
      'cat_medical': '医疗',
      'cat_education': '教育',
      'cat_salary': '薪资',
      'cat_other': '其他',
    };
    return names[id] ?? '其他';
  }

  String _getAccName(String id) {
    const names = {
      'acc_cmb': '招商银行',
      'acc_alipay': '支付宝',
      'acc_wechat': '微信',
      'acc_cash': '现金',
    };
    return names[id] ?? '其他';
  }
}
