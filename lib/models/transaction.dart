import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

enum TransactionType { income, expense }

@JsonSerializable()
class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String categoryId;
  final String accountId;
  final DateTime date;
  final String? note;
  final String? tags;
  final DateTime createdAt;

  Transaction({
    String? id,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.accountId,
    required this.date,
    this.note,
    this.tags,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  String get typeStr => type == TransactionType.income ? 'income' : 'expense';

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  Transaction copyWith({
    TransactionType? type,
    double? amount,
    String? categoryId,
    String? accountId,
    DateTime? date,
    String? note,
    String? tags,
  }) {
    return Transaction(
      id: id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      note: note ?? this.note,
      tags: tags ?? this.tags,
      createdAt: createdAt,
    );
  }
}
