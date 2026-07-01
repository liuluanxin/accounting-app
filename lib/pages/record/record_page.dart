import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/category_grid.dart';
import '../../utils/date_utils.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  bool _isExpense = true;
  final _amountController = TextEditingController(text: '32.00');
  String _selectedCategoryId = 'cat_food';
  DateTime _selectedDate = DateTime.now();
  String _selectedAccount = 'acc_cmb';
  String _selectedTags = '日常 · 午餐';

  final _catItems = [
    _CatItemData('cat_food', '🍱', const Color(0xFFFFF3E0)),
    _CatItemData('cat_transport', '🚇', const Color(0xFFE8F5E9)),
    _CatItemData('cat_shopping', '🛒', const Color(0xFFFCE4EC)),
    _CatItemData('cat_entertain', '🎬', const Color(0xFFF3E5F5)),
    _CatItemData('cat_housing', '🏠', const Color(0xFFFFF8E1)),
    _CatItemData('cat_medical', '💊', const Color(0xFFE8F5E9)),
    _CatItemData('cat_education', '📚', const Color(0xFFE0F7FA)),
    _CatItemData('cat_other', '📦', const Color(0xFFF5F5F5)),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.bgGradientStart,
              AppTheme.bgGradientMid,
              AppTheme.bgGradientEnd,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                // 顶部导航
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Row(
                          children: [
                            Icon(Icons.chevron_left,
                                size: 22, color: AppTheme.primary),
                            SizedBox(width: 4),
                            Text('记一笔',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textMain)),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_horiz, color: AppTheme.textMain),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 类型切换
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E8FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _buildTypeBtn('支出', true, _isExpense),
                        _buildTypeBtn('收入', false, !_isExpense),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 金额输入
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¥',
                        style: TextStyle(
                            fontSize: 24, color: AppTheme.textSub)),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _amountController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: TextStyle(color: Color(0xFFa0a0a0)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 选择分类
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('选择分类',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSub,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildCatGrid(),
                ),
                const SizedBox(height: 12),
                // 表单字段
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildField('日期',
                      '${DateUtils.formatDate(_selectedDate)} 周${DateUtils.formatDayOfWeek(_selectedDate)}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildField('账户', '招商银行 (储蓄卡)'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildField('标签', _selectedTags),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildField('备注', '添加备注...', isNote: true),
                ),
                const SizedBox(height: 16),
                // 保存按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: _saveTransaction,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('保存',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBtn(String text, bool isExpense, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpense = isExpense;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFB4A0C8).withOpacity(0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? (isExpense ? AppTheme.expense : AppTheme.income)
                    : AppTheme.textSub,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCatGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _catItems.length,
      itemBuilder: (context, index) {
        final item = _catItems[index];
        final isSelected = item.id == _selectedCategoryId;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategoryId = item.id;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF0E8FA) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(item.icon, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.name,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMain)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(String label, String value, {bool isNote = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.textSub)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F0FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isNote ? AppTheme.textSub : AppTheme.textMain,
                  ),
                ),
                const Icon(Icons.chevron_right,
                    size: 12, color: AppTheme.textSub),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveTransaction() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    final tx = Transaction(
      type: _isExpense ? TransactionType.expense : TransactionType.income,
      amount: amount,
      categoryId: _selectedCategoryId,
      accountId: _selectedAccount,
      date: _selectedDate,
      note: _catItems
          .firstWhere((c) => c.id == _selectedCategoryId)
          .name,
    );

    context.read<TransactionProvider>().addTransaction(tx);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功！'),
          duration: Duration(seconds: 1)),
    );
    Navigator.pop(context);
  }
}

class _CatItemData {
  final String id;
  final String icon;
  final Color bgColor;
  final String name;

  _CatItemData(this.id, this.icon, this.bgColor)
      : name = {
          'cat_food': '餐饮',
          'cat_transport': '交通',
          'cat_shopping': '购物',
          'cat_entertain': '娱乐',
          'cat_housing': '居住',
          'cat_medical': '医疗',
          'cat_education': '教育',
          'cat_other': '其他',
        }[id] ?? '其他';
}
