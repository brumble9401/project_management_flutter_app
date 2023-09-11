class TaskModel {
  String? id;
  String? name;
  String? description;
  DateTime? deadline;
  String? state;
  DateTime? finishedTime;
  List<String>? userIds;
  DateTime? createdDate;
  String? workspaceId;

  TaskModel(
      {this.id,
      this.name,
      this.description,
      this.deadline,
      this.state,
      this.finishedTime,
      this.userIds,
      this.createdDate,
        this.workspaceId,
      });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    deadline = json['deadline'];
    state = json['finish'];
    finishedTime = json['finish_time'];
    if (json['member'] != null) {
      userIds = <String>[];
      json['member'].forEach((v) {
        userIds!.add(v);
      });
    }
    createdDate = json['created_date'];
    workspaceId = json['workspaceId'];
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
    data['created_date'] = this.createdDate;
    return data;
  }
}
