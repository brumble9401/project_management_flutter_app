class WorkspaceModel {
  String? uid;
  String? workspaceName;
  List<String>? workspaceLeaderId;
  List<String>? userIds;

  WorkspaceModel(
      {this.uid, this.workspaceName, this.workspaceLeaderId, this.userIds});

  WorkspaceModel.fromJson(Map<String, dynamic> json) {
    uid = json['id'];
    workspaceName = json['workspace_name'];
    if (json['leaders_id'] != null) {
      workspaceLeaderId = <String>[];
      json['leaders_id'].forEach((v) {
        workspaceLeaderId!.add(v);
      });
    }
    if (json['userIds'] != null) {
      userIds = <String>[];
      json['userIds'].forEach((v) {
        userIds!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['workspace_name'] = this.workspaceName;
    data['leaders_id'] = this.workspaceLeaderId;
    if (this.userIds != null) {
      data['userIds'] = this.userIds!.map((v) => v);
    }
    return data;
  }
}
