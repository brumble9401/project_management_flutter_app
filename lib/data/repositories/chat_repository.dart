import 'package:pma_dclv/data/data_source/remote/chat_remote.dart';

import '../models/chat/chat_room.dart';

class ChatRepository {
  late final ChatRemoteSource _chatRemoteSource;

  ChatRepository._internal() {
    _chatRemoteSource = ChatRemoteSource();
  }

  static final _instance = ChatRepository._internal();

  factory ChatRepository.instance() => _instance;

  Stream<List<ChatRoom>> getChatRooms(String userId) async* {
    yield* _chatRemoteSource.getChatRooms(userId);
  }

  Stream<ChatRoom> getRoom(String userId1, String userId2) async* {
    yield* _chatRemoteSource.getRoom(userId1, userId2);
  }

  Stream<ChatRoom> getRoomFromRoomUid(String roomId) async* {
    yield* _chatRemoteSource.getRoomFromRoomUid(roomId);
  }

  Stream<List<MessageModel>> getMessages(String chatRoomId) async* {
    final Stream<List<MessageModel>> messageStream =
        _chatRemoteSource.getMessages(chatRoomId);
    await for (final List<MessageModel> messages in messageStream) {
      yield messages;
    }
  }

  Future<String> createChatRoom(String userId1, String userId2) async {
    return await _chatRemoteSource.createChatRoom(userId1, userId2);
  }

  Future<void> sendMessage(
      String chatRoomId, String sender, String text) async {
    await _chatRemoteSource.sendMessage(chatRoomId, sender, text);
  }
}
