class NotificationModel {
  String? uid;
  String? title;
  String? body;
  Map<String, dynamic>? payload;
  String? receiver;
  DateTime? createdDate;
  String? read;

  NotificationModel({
    this.uid,
    this.title,
    this.body,
    this.payload,
    this.receiver,
    this.createdDate,
    this.read,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    uid = json['id'];
    title = json['title'];
    body = json['body'];
    receiver = json['receiver'];
    createdDate = json['created_date'];
    payload = json['payload'];
    read = json['read'];
  }
}