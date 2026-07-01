import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/account_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/budget_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
      ],
      child: const _AccountingAppWrapper(),
    ),
  );
}

class _AccountingAppWrapper extends StatelessWidget {
  const _AccountingAppWrapper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '宇宙记账',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AccountingApp(),
    );
  }
}
