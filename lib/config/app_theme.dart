import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // 主色
  static const Color primary = Color(0xFF6BA8D9);
  static const Color primaryDark = Color(0xFF4A7FB5);
  static const Color primaryLight = Color(0xFFA8D4E8);

  // 功能色
  static const Color income = Color(0xFFE89B9B);
  static const Color expense = Color(0xFF7BC4A8);

  // 文字色
  static const Color textMain = Color(0xFF1F2A47);
  static const Color textSub = Color(0xFF5A6788);
  static const Color textWhite = Color(0xFFFFFFFF);

  // 背景色
  static const Color bg = Color(0xFFF4F6FB);
  static const Color bgGradientStart = Color(0xFFB8C8E8);
  static const Color bgGradientMid = Color(0xFFD8C8E4);
  static const Color bgGradientEnd = Color(0xFFF4E8D8);

  // 卡片渐变
  static const Color heroFrom = Color(0xFFB5E8D5);
  static const Color heroTo = Color(0xFFC5B8E8);
  static const Color budgetFrom = Color(0xFFF0E8F8);
  static const Color budgetTo = Color(0xFFE8F4F0);

  // 强调色
  static const Color accentWarm = Color(0xFFFFD89E);
  static const Color accentSage = Color(0xFFA8E0D0);
  static const Color pastelYellow = Color(0xFFFFE9A8);
  static const Color pastelLavender = Color(0xFFE0D4F0);

  // 宇宙色系
  static const Color cosmicCoin = Color(0xFFFFD89E);

  // 卡片圆角
  static const double cardRadius = 16.0;

  // 导航栏高度
  static const double navHeight = 70.0;
  static const double statusHeight = 44.0;

  // 毛玻璃背景透明度
  static const double frostedOpacity = 0.85;

  static ThemeData get theme => ThemeData(
        useMaterial3: false,
        fontFamily: 'PingFang SC',
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: primaryLight,
          surface: Colors.white,
          error: income,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

  static BoxDecoration get heroCardDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        gradient: const LinearGradient(
          colors: [heroFrom, primaryLight, heroTo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB4A0C8).withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get budgetCardDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        gradient: const LinearGradient(
          colors: [budgetFrom, Color(0xFFF8ECD8), budgetTo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB4A0C8).withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration get frostedCardDecoration => BoxDecoration(
        color: Colors.white.withOpacity(frostedOpacity),
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB4A0C8).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      );
}
