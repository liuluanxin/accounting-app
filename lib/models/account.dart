import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final String id;
  final String name;
  final String? icon;
  final double balance;
  final String? description;
  final String? color;

  Account({
    String? id,
    required this.name,
    this.icon,
    this.balance = 0,
    this.description,
    this.color,
  }) : id = id ?? const Uuid().v4();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Account copyWith({
    String? name,
    String? icon,
    double? balance,
    String? description,
    String? color,
  }) {
    return Account(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      balance: balance ?? this.balance,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }
}
