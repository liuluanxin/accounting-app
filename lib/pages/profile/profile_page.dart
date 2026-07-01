import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 个人信息头部
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF4F0FA), Color(0xFFE8F4F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0D4F0)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryDark],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.person,
                        size: 28, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('张小明',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMain)),
                      SizedBox(height: 4),
                      Text('ID: 123456789',
                          style: TextStyle(
                              fontSize: 13, color: AppTheme.textSub)),
                    ],
                  ),
                ),
                const Icon(Icons.qr_code,
                    size: 20, color: AppTheme.primary),
              ],
            ),
          ),
          // 菜单组 1
          _buildMenuSection([
            _MenuItemData(Icons.history, '账单记录', AppTheme.primary),
            _MenuItemData(Icons.label_outline, '分类管理', AppTheme.expense),
            _MenuItemData(Icons.settings, '设置', AppTheme.textSub),
          ]),
          const SizedBox(height: 8),
          // 菜单组 2
          _buildMenuSection([
            _MenuItemData(Icons.shield_outlined, '账户安全', AppTheme.primary),
            _MenuItemData(Icons.download_outlined, '数据备份', AppTheme.primary),
            _MenuItemData(Icons.file_upload_outlined, '导出账单', AppTheme.expense),
            _MenuItemData(Icons.language, '多语言', AppTheme.primary,
                trailing: '中文'),
          ]),
          const SizedBox(height: 8),
          // 菜单组 3
          _buildMenuSection([
            _MenuItemData(Icons.help_outline, '帮助与反馈', AppTheme.primary),
            _MenuItemData(Icons.info_outline, '关于', AppTheme.textSub,
                trailing: 'v1.0.0'),
          ]),
        ],
      ),
    );
  }

  Widget _buildMenuSection(List<_MenuItemData> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB4A0C8).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: items.indexOf(item) < items.length - 1
                  ? const Border(
                      bottom: BorderSide(color: Color(0xFFF4F0FA)),
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(item.icon, size: 20, color: item.color),
                    const SizedBox(width: 12),
                    Text(item.label,
                        style: const TextStyle(
                            fontSize: 15, color: AppTheme.textMain)),
                  ],
                ),
                Row(
                  children: [
                    if (item.trailing != null)
                      Text(item.trailing!,
                          style: const TextStyle(
                              fontSize: 13, color: AppTheme.textSub)),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right,
                        size: 16, color: AppTheme.textSub),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String label;
  final Color color;
  final String? trailing;

  _MenuItemData(this.icon, this.label, this.color, {this.trailing});
}
