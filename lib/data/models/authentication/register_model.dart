class RegisterModel {
  String? username;
  String? first_name;
  String? last_name;
  String? email;

  RegisterModel({
    this.email,
    this.first_name,
    this.last_name,
    this.username,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['email'] = this.email;
    return data;
  }
}
