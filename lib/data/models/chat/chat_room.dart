class MessageModel {
  final String id;
  final String content;
  final String senderId;
  final DateTime createdDate;
  final List<String> readBy;
  final String type;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.createdDate,
    required this.readBy,
    required this.type,
  });
}

class ChatRoom {
  final String? id;
  final List<String>? users;
  final List<MessageModel>? messages;
  final String? lastMess;
  final DateTime? createdDate;
  final String? read;
  final String? sender;

  ChatRoom({
    this.id,
    this.users,
    this.messages,
    this.lastMess,
    this.createdDate,
    this.read,
    this.sender,
  });
}
