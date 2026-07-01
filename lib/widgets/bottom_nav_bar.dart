import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/constants.dart';

class BottomNavBar extends StatelessWidget {
  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItemData(AppTab.home, Icons.home_outlined, Icons.home, '首页'),
      _NavItemData(AppTab.calendar, Icons.calendar_today_outlined,
          Icons.calendar_today, '日历'),
      _NavItemData(AppTab.assets, Icons.savings_outlined, Icons.savings, '资产'),
      _NavItemData(AppTab.stats, Icons.pie_chart_outlined, Icons.pie_chart, '统计'),
      _NavItemData(AppTab.profile, Icons.person_outline, Icons.person, '我的'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB4A0C8).withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          final isActive = item.tab == currentTab;
          return GestureDetector(
            onTap: () => onTabSelected(item.tab),
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isActive ? item.activeIcon : item.icon,
                    size: 20,
                    color: isActive ? Colors.white : AppTheme.textSub,
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 4),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItemData {
  final AppTab tab;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _NavItemData(this.tab, this.icon, this.activeIcon, this.label);
}
