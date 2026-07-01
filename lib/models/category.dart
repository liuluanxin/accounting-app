import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

enum CategoryType { income, expense }

@JsonSerializable()
class Category {
  final String id;
  final String name;
  final String? icon;
  final String type; // 'income' | 'expense'
  final int sortOrder;

  Category({
    required this.id,
    required this.name,
    this.icon,
    required this.type,
    this.sortOrder = 0,
  });

  CategoryType get categoryType =>
      type == 'income' ? CategoryType.income : CategoryType.expense;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
