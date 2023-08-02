class ProjectModel {
  String? id;
  String? name;
  String? description;
  DateTime? deadline;
  String? state;
  DateTime? finishedTime;
  List<String>? userIds;
  String? workspaceId;
  DateTime? createdDate;
  List<String>? comments;

  ProjectModel(
      {this.id,
      this.name,
      this.description,
      this.deadline,
      this.state,
      this.finishedTime,
      this.userIds,
      this.workspaceId,
      this.createdDate});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    deadline = json['deadline'];
    state = json['state'];
    finishedTime = json['finish_time'];
    if (json['member'] != null) {
      userIds = <String>[];
      json['member'].forEach((v) {
        userIds!.add(v);
      });
    }
    if (json['comments'] != null) {
      comments = <String>[];
      json['comments'].forEach((v) {
        comments!.add(v);
      });
    }
    workspaceId = json['workspace'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['deadline'] = this.deadline;
    data['finish'] = this.state;
    data['finish_time'] = this.finishedTime;
    if (this.userIds != null) {
      data['member'] = this.userIds!.map((v) => v);
    }
    if (this.workspaceId != null) {
      data['workspace'] = this.workspaceId;
    }
    data['created_date'] = this.createdDate;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v);
    }
    return data;
  }
}
