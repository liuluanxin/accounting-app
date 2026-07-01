import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'budget.g.dart';

@JsonSerializable()
class Budget {
  final String id;
  final String month; // '2026-07' 格式
  final double totalAmount;
  final String? categoryId; // null 表示总预算
  final double amount;

  Budget({
    String? id,
    required this.month,
    this.totalAmount = 0,
    this.categoryId,
    this.amount = 0,
  }) : id = id ?? const Uuid().v4();

  factory Budget.fromJson(Map<String, dynamic> json) =>
      _$BudgetFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetToJson(this);

  Budget copyWith({
    double? totalAmount,
    double? amount,
  }) {
    return Budget(
      id: id,
      month: month,
      totalAmount: totalAmount ?? this.totalAmount,
      categoryId: categoryId,
      amount: amount ?? this.amount,
    );
  }
}
