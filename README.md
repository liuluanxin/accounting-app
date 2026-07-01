# 🪐 宇宙记账 App

一款基于 Flutter 构建的跨平台手机端记账应用，宇宙星空主题，支持 iOS / Android。

## 功能特性

| 页面 | 功能 |
|------|------|
| **登录页** | 手机号/邮箱密码登录，第三方快捷登录入口 |
| **首页** | 月度结余卡片、预算卡片、按日期分组的交易流水、快捷记账 FAB |
| **日历页** | 月历网格展示每日收支、选中日期查看详情、当天汇总 |
| **资产页** | 总资产展示、多账户余额列表、添加账户入口 |
| **统计页** | 支出/收入/资产切换、环形图、分类占比、支出排行 |
| **我的页** | 个人信息、菜单入口（账单、分类、设置、安全、备份等） |
| **记一笔** | 收支类型切换、金额输入、分类选择、日期/账户/标签/备注、保存 |

## 技术栈

- **框架**: Flutter 3.x (Dart)
- **状态管理**: Provider 6.x
- **本地存储**: SQLite (sqflite)
- **图标**: Material Icons
- **数据序列化**: json_serializable

## 目录结构

```
accounting-app/
├── pubspec.yaml
├── analysis_options.yaml
├── assets/images/
│   └── phone-bg.png              # 宇宙背景图
├── lib/
│   ├── main.dart                 # 应用入口
│   ├── app.dart                  # 根 Widget 与导航
│   ├── config/
│   │   ├── app_theme.dart        # 主题色、样式
│   │   └── constants.dart        # 常量定义
│   ├── models/
│   │   ├── transaction.dart      # 交易模型
│   │   ├── account.dart          # 账户模型
│   │   ├── category.dart         # 分类模型
│   │   ├── budget.dart           # 预算模型
│   │   └── user.dart             # 用户模型
│   ├── database/
│   │   ├── database_helper.dart  # SQLite 单例
│   │   └── tables.dart           # 表名/字段常量
│   ├── repositories/
│   │   ├── transaction_repository.dart
│   │   ├── account_repository.dart
│   │   ├── category_repository.dart
│   │   └── budget_repository.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── transaction_provider.dart
│   │   ├── account_provider.dart
│   │   ├── calendar_provider.dart
│   │   ├── stats_provider.dart
│   │   └── budget_provider.dart
│   ├── pages/
│   │   ├── login/login_page.dart
│   │   ├── home/home_page.dart
│   │   ├── calendar/calendar_page.dart
│   │   ├── assets/assets_page.dart
│   │   ├── stats/stats_page.dart
│   │   ├── profile/profile_page.dart
│   │   └── record/record_page.dart
│   └── widgets/
│       ├── hero_card.dart         # 月结余卡片
│       ├── budget_card.dart       # 预算卡片
│       ├── transaction_item.dart  # 交易列表项
│       ├── bottom_nav_bar.dart    # 底部导航栏
│       ├── category_grid.dart     # 分类网格
│       ├── donut_chart.dart       # 环形图
│       └── empty_state.dart       # 空状态
└── test/
    ├── models/
    │   ├── transaction_test.dart
    │   └── account_test.dart
    └── utils/
        └── number_utils_test.dart
```

## 运行步骤

### 环境要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### 安装与运行

```bash
# 1. 进入项目目录
cd accounting-app

# 2. 安装依赖
flutter pub get

# 3. 生成序列化代码（如果修改了模型）
flutter pub run build_runner build

# 4. 启动（连接设备或模拟器）
flutter run

# 5. 构建 APK
flutter build apk --release

# 6. 构建 iOS
flutter build ios --release
```

## 数据说明

应用使用 SQLite 本地数据库，首次启动时自动创建表结构并初始化以下示例数据：

- **4 个默认账户**: 招商银行、支付宝、微信、现金
- **12 个默认分类**: 餐饮、交通、购物、娱乐、居住、医疗、教育、薪资等
- **5 条示例交易**: 咖啡、买菜、工资、外卖、地铁
- **1 个月度预算**: ¥1,500
- **1 个默认用户**: 张小明

所有数据存储在本地，无需网络权限。

## 架构设计

### 数据流

```
UI (Widgets) → Provider (状态管理) → Repository (数据仓库) → DatabaseHelper (SQLite)
```

### 状态管理方案

- **全局状态**: AuthProvider（登录状态）
- **页面状态**: TransactionProvider、AccountProvider、CalendarProvider、StatsProvider、BudgetProvider
- 采用 Provider 的 ChangeNotifier 模式，异步操作处理 loading / success / error 三态

### 数据库设计

5 张表：transactions（交易）、accounts（账户）、categories（分类）、budgets（预算）、users（用户）

## 已知限制

1. 当前「记一笔」页面的分类图标使用硬编码 emoji，后续可通过数据库分类数据动态渲染
2. 日历尚未支持月份切换后刷新交易数据（已完成 Provider 层，需 UI 接入）
3. 统计页的「资产」切换按钮暂无独立数据视图
4. 未集成第三方推送、支付、地图等扩展功能

## 后续优化建议

1. 添加交易编辑功能（当前仅支持新增）
2. 数据导出（CSV/Excel）
3. 预算按分类细分设置
4. 云备份与多设备同步
5. 深色模式支持
6. Biometric 登录（指纹/面容）
