import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/account_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/budget_provider.dart';
import 'pages/login/login_page.dart';
import 'pages/home/home_page.dart';
import 'pages/calendar/calendar_page.dart';
import 'pages/assets/assets_page.dart';
import 'pages/stats/stats_page.dart';
import 'pages/profile/profile_page.dart';
import 'widgets/bottom_nav_bar.dart';

class AccountingApp extends StatefulWidget {
  const AccountingApp({super.key});

  @override
  State<AccountingApp> createState() => _AccountingAppState();
}

class _AccountingAppState extends State<AccountingApp> {
  AppTab _currentTab = AppTab.home;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadUser();
    });
  }

  void _onTabSelected(AppTab tab) {
    setState(() => _currentTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isLoggedIn) {
      return Container(
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
        child: const LoginPage(),
      );
    }

    return Container(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // 页面内容
              IndexedStack(
                index: _currentTab.index,
                children: [
                  const HomePage(),
                  const CalendarPage(),
                  const AssetsPage(),
                  const StatsPage(),
                  const ProfilePage(),
                ],
              ),
              // 底部导航
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomNavBar(
                  currentTab: _currentTab,
                  onTabSelected: _onTabSelected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
