import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/account_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/hero_card.dart';
import '../../widgets/budget_card.dart';
import '../../widgets/transaction_item.dart';
import '../../utils/date_utils.dart';
import '../../utils/number_utils.dart';
import '../record/record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final month = DateUtils.monthKey(now);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions(month: month);
      context.read<BudgetProvider>().loadBudget(month);
      context.read<AccountProvider>().loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final bgtProvider = context.watch<BudgetProvider>();
    final accProvider = context.watch<AccountProvider>();

    final now = DateTime.now();
    final monthKey = DateUtils.monthKey(now);
    final groupedTx = txProvider.groupedByDate;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部标题
              _buildHeader(context),
              // 月份导航
              _buildDateNav(),
              // 结余卡片
              HeroCard(
                label: '月结余',
                amount: NumberUtils.formatYuan(txProvider.monthlyBalance),
                incomeText: '收入 ${NumberUtils.formatYuan(txProvider.monthlyIncome)}',
                expenseText: '支出 ${NumberUtils.formatYuan(txProvider.monthlyExpense)}',
              ),
              // 预算卡片
              BudgetCard(
                totalAmount: bgtProvider.currentBudget?.totalAmount ?? 0,
                usedAmount: bgtProvider.monthlyExpense,
                categories: const [],
              ),
              const SizedBox(height: 8),
              // 交易列表
              ...groupedTx.entries.map((entry) {
                final date = DateTime.parse(entry.key);
                final incomeTotal = entry.value
                    .where((t) => t.type.name == 'income')
                    .fold(0.0, (s, t) => s + t.amount);
                final expenseTotal = entry.value
                    .where((t) => t.type.name == 'expense')
                    .fold(0.0, (s, t) => s + t.amount);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${DateUtils.formatDateLabel(date)} ${DateUtils.formatDate(date)}',
                            style: const TextStyle(
                                fontSize: 14, color: AppTheme.textSub),
                          ),
                          Text(
                            '收入: ${NumberUtils.formatYuan(incomeTotal)} 支出: ${NumberUtils.formatYuan(expenseTotal)}',
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.textSub),
                          ),
                        ],
                      ),
                    ),
                    ...entry.value.map((tx) {
                      // 这里简化了分类图标的显示
                      return TransactionItem(
                        iconText: tx.categoryId == 'cat_food'
                            ? '🍱'
                            : tx.categoryId == 'cat_transport'
                                ? '🚇'
                                : tx.categoryId == 'cat_salary'
                                    ? '💼'
                                    : '📦',
                        isExpense: tx.type.name == 'expense',
                        title: tx.note ?? '记账',
                        meta:
                            '${DateUtils.formatTime(tx.date)} · ${_getCategoryName(tx.categoryId)}',
                        amount:
                            '${tx.type.name == 'expense' ? '-' : '+'}${NumberUtils.formatAmount(tx.amount)}',
                        method: _getAccountName(tx.accountId),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RecordPage()),
                          );
                        },
                      );
                    }),
                  ],
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
        // 浮动按钮
        Positioned(
          right: 20,
          bottom: 80,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecordPage()),
              );
            },
            backgroundColor: AppTheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text('🪐', style: TextStyle(fontSize: 24)),
              SizedBox(width: 6),
              Text('宇宙记账',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMain)),
              Icon(Icons.chevron_right,
                  size: 12, color: AppTheme.textSub),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  size: 20, color: AppTheme.primary),
              const SizedBox(width: 16),
              Icon(Icons.more_horiz,
                  size: 20, color: AppTheme.textMain.withOpacity(0.7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateNav() {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                DateUtils.formatMonth(now),
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.textMain),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_left,
                  size: 16, color: AppTheme.textSub),
              const Icon(Icons.chevron_right,
                  size: 16, color: AppTheme.textSub),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F0FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0D4F0)),
            ),
            child: const Row(
              children: [
                Text('按月显示',
                    style:
                        TextStyle(fontSize: 13, color: AppTheme.textSub)),
                SizedBox(width: 4),
                Icon(Icons.chevron_right,
                    size: 12, color: AppTheme.textSub),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String id) {
    const names = {
      'cat_food': '餐饮',
      'cat_transport': '交通',
      'cat_shopping': '购物',
      'cat_entertain': '娱乐',
      'cat_housing': '居住',
      'cat_medical': '医疗',
      'cat_education': '教育',
      'cat_salary': '薪资',
      'cat_invest': '理财',
      'cat_other': '其他',
    };
    return names[id] ?? '其他';
  }

  String _getAccountName(String id) {
    const names = {
      'acc_cmb': '招商银行',
      'acc_alipay': '支付宝',
      'acc_wechat': '微信',
      'acc_cash': '现金',
    };
    return names[id] ?? '其他';
  }
}
