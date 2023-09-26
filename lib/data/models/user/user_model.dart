import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;
  List<String>? workspaceIds;
  String? pushToken;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
    this.workspaceIds,
    this.pushToken,
  });

  factory UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() ?? {};
    return UserModel(
      id: doc.id,
      firstName: data?['first_name'] ?? '',
      lastName: data?['last_name'] ?? '',
      email: data?['email'] ?? '',
      avatar: data?['avatar'] ?? '',
      pushToken: data?['pushToken'] ?? '',
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    avatar = json['avatar'];
    pushToken = json['pushToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['pushToken'] = this.pushToken;
    return data;
  }
}
