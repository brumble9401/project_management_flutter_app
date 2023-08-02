import 'package:hive/hive.dart';

part 'user_adapter.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0, defaultValue: "")
  String? access_token;

  @HiveField(1, defaultValue: "")
  String? refresh_token;

  @HiveField(2, defaultValue: "")
  String? username;

  @HiveField(3, defaultValue: "")
  String? first_name;

  @HiveField(4, defaultValue: "")
  String? last_name;

  @HiveField(5, defaultValue: "")
  String? email;

  @HiveField(6, defaultValue: "")
  String? avatar;

  @HiveField(7, defaultValue: "")
  String? id;

  User({
    this.access_token,
    this.avatar,
    this.email,
    this.first_name,
    this.id,
    this.last_name,
    this.refresh_token,
    this.username,
  });
}
