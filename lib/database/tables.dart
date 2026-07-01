class Tables {
  Tables._();

  static const String transactions = 'transactions';
  static const String accounts = 'accounts';
  static const String categories = 'categories';
  static const String budgets = 'budgets';
  static const String users = 'users';

  // transactions 字段
  static const String txId = 'id';
  static const String txType = 'type'; // 'income' | 'expense'
  static const String txAmount = 'amount';
  static const String txCategoryId = 'category_id';
  static const String txAccountId = 'account_id';
  static const String txDate = 'date';
  static const String txNote = 'note';
  static const String txTags = 'tags';
  static const String txCreatedAt = 'created_at';

  // accounts 字段
  static const String accId = 'id';
  static const String accName = 'name';
  static const String accIcon = 'icon';
  static const String accBalance = 'balance';
  static const String accDesc = 'description';
  static const String accColor = 'color';

  // categories 字段
  static const String catId = 'id';
  static const String catName = 'name';
  static const String catIcon = 'icon';
  static const String catType = 'type'; // 'income' | 'expense'
  static const String catSortOrder = 'sort_order';

  // budgets 字段
  static const String bgtId = 'id';
  static const String bgtMonth = 'month'; // '2026-07' 格式
  static const String bgtTotal = 'total_amount';
  static const String bgtCategoryId = 'category_id';
  static const String bgtAmount = 'amount';

  // users 字段
  static const String userId = 'id';
  static const String userNickname = 'nickname';
  static const String userPhone = 'phone';
  static const String userAvatar = 'avatar';
}
