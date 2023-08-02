class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;
  List<String>? workspaceIds;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.avatar,
      this.workspaceIds});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    return data;
  }
}
