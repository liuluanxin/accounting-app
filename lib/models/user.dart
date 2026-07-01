import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

@JsonSerializable()
class AppUser {
  final String id;
  final String nickname;
  final String? phone;
  final String? avatar;

  AppUser({
    String? id,
    this.nickname = '用户',
    this.phone,
    this.avatar,
  }) : id = id ?? const Uuid().v4();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
