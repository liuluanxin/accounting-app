import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/account_provider.dart';
import '../../utils/number_utils.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accProvider = context.watch<AccountProvider>();

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
                    Icon(Icons.savings,
                        size: 20, color: AppTheme.primary),
                    SizedBox(width: 8),
                    Text('资产',
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
          // 总资产
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Column(
              children: [
                const Text('总资产',
                    style: TextStyle(
                        fontSize: 14, color: AppTheme.textSub)),
                const SizedBox(height: 8),
                Text(
                  NumberUtils.formatYuan(accProvider.totalBalance),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_upward,
                        size: 14, color: AppTheme.expense),
                    SizedBox(width: 4),
                    Text('较上月 +¥2,345.67',
                        style: TextStyle(
                            fontSize: 13, color: AppTheme.expense)),
                  ],
                ),
              ],
            ),
          ),
          // 账户列表卡片
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: AppTheme.frostedCardDecoration,
            child: Column(
              children: [
                ...accProvider.accounts.map((acc) => _buildAccountItem(
                      icon: _getAccountIcon(acc.icon),
                      iconBg: _getAccountBg(acc.icon),
                      iconColor: _getAccountColor(acc.icon),
                      name: acc.name,
                      desc: acc.description ?? '',
                      balance: acc.balance,
                    )),
                // 添加账户
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Color(0xFFE0D4F0), style: BorderStyle.solid),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline,
                            size: 16, color: AppTheme.primary),
                        SizedBox(width: 8),
                        Text('添加账户',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem({
    required String icon,
    required Color iconBg,
    required Color iconColor,
    required String name,
    required String desc,
    required double balance,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: TextStyle(fontSize: 20, color: iconColor)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textSub)),
              ],
            ),
          ),
          Text(
            NumberUtils.formatYuan(balance),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMain),
          ),
        ],
      ),
    );
  }

  String _getAccountIcon(String? icon) {
    switch (icon) {
      case 'credit-card':
        return '💳';
      case 'alipay':
        return '💰';
      case 'weixin':
        return '💬';
      case 'money-bill-wave':
        return '💵';
      default:
        return '🏦';
    }
  }

  Color _getAccountBg(String? icon) {
    switch (icon) {
      case 'credit-card':
        return const Color(0xFFE8F0FA);
      case 'alipay':
        return const Color(0xFFF4F0FA);
      case 'weixin':
        return const Color(0xFFE0F0EA);
      case 'money-bill-wave':
        return const Color(0xFFFFF4E0);
      default:
        return const Color(0xFFF0E8FA);
    }
  }

  Color _getAccountColor(String? icon) {
    switch (icon) {
      case 'credit-card':
        return AppTheme.primary;
      case 'alipay':
        return AppTheme.primary;
      case 'weixin':
        return AppTheme.expense;
      case 'money-bill-wave':
        return const Color(0xFFE8B96E);
      default:
        return AppTheme.textMain;
    }
  }
}
