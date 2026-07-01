enum AppTab { home, calendar, assets, stats, profile }

const String appName = '宇宙记账';
const String appVersion = '1.0.0';

// 数据库名
const String databaseName = 'accounting.db';
const int databaseVersion = 1;

// 默认分类
const List<Map<String, String>> defaultExpenseCategories = [
  {'id': 'cat_food', 'name': '餐饮', 'icon': '🍱'},
  {'id': 'cat_transport', 'name': '交通', 'icon': '🚇'},
  {'id': 'cat_shopping', 'name': '购物', 'icon': '🛒'},
  {'id': 'cat_entertain', 'name': '娱乐', 'icon': '🎬'},
  {'id': 'cat_housing', 'name': '居住', 'icon': '🏠'},
  {'id': 'cat_medical', 'name': '医疗', 'icon': '💊'},
  {'id': 'cat_education', 'name': '教育', 'icon': '📚'},
  {'id': 'cat_other', 'name': '其他', 'icon': '📦'},
];

const List<Map<String, String>> defaultIncomeCategories = [
  {'id': 'cat_salary', 'name': '薪资', 'icon': '💼'},
  {'id': 'cat_invest', 'name': '理财', 'icon': '📈'},
  {'id': 'cat_parttime', 'name': '兼职', 'icon': '💻'},
  {'id': 'cat_other_inc', 'name': '其他', 'icon': '💰'},
];
