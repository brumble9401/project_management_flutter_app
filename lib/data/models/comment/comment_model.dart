class CommentModel {
  String? uid;
  String? userUid;
  String? content;
  DateTime? createdDate;
  String? taskUid;
  String? projectUid;

  CommentModel({
    this.uid,
    this.userUid,
    this.content,
    this.createdDate,
    this.taskUid,
    this.projectUid,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    uid = json['id'];
    userUid = json['user'];
    content = json['content'];
    createdDate = json['created_date'];
    taskUid = json['taskUid'];
    projectUid = json['projectUid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.uid;
    data['userUid'] = this.userUid;
    data['content'] = this.content;
    data['created_date'] = this.createdDate;
    data['taskUid'] = this.taskUid;
    data['projectUid'] = this.projectUid;
    return data;
  }
}

class CommentModelRes {
  int? id;
  int? user;
  String? content;
  String? createdDate;

  CommentModelRes({this.id, this.user, this.content, this.createdDate});

  CommentModelRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    content = json['content'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['content'] = this.content;
    data['created_date'] = this.createdDate;
    return data;
  }
}
