import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/data/repositories/chat_repository.dart';
import 'package:pma_dclv/utils/log_util.dart';

import '../../data/models/chat/chat_room.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState.initial());

  final _chatRepository = ChatRepository.instance();

  Stream<List<ChatRoom>> getChatRooms(String userId) async* {
    try {
      emit(state.copyWith(chatStatus: ChatStatus.loading));
      yield* _chatRepository.getChatRooms(userId);
      emit(state.copyWith(chatStatus: ChatStatus.success));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.fail));
      LogUtil.error("Get chat rooms failed");
    }
  }

  Stream<ChatRoom> getRoom(String userId1, String userId2) async* {
    try {
      emit(state.copyWith(chatStatus: ChatStatus.loading));
      yield* _chatRepository.getRoom(userId1, userId2);
      emit(state.copyWith(chatStatus: ChatStatus.success));
      LogUtil.error("Get chat room success");
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.fail));
      LogUtil.error("Get chat room failed");
    }
  }

  Stream<ChatRoom> getRoomFromRoomUid(String roomId) async* {
    try {
      emit(state.copyWith(chatStatus: ChatStatus.loading));
      yield* _chatRepository.getRoomFromRoomUid(roomId);
      emit(state.copyWith(chatStatus: ChatStatus.success));
      LogUtil.error("Get chat room success");
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.fail));
      LogUtil.error("Get chat room failed");
    }
  }

  Future<String> createChatRoom(String userId1, String userId2) async {
    try {
      emit(state.copyWith(chatStatus: ChatStatus.loading));
      String uid = await _chatRepository.createChatRoom(userId1, userId2);
      emit(state.copyWith(chatStatus: ChatStatus.success));
      LogUtil.error("Create chat room success");

      return uid;
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.fail));
      LogUtil.error("Create chat room failed");
      return "";
    }
  }

  Stream<List<MessageModel>> getMessages(String chatRoomId) async* {
    try {
      emit(state.copyWith(chatStatus: ChatStatus.loading));
      yield* _chatRepository.getMessages(chatRoomId);
      emit(state.copyWith(chatStatus: ChatStatus.success));
      LogUtil.error("Get messages room success");
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.fail));
      LogUtil.error("Get messages room failed");
    }
  }

  Future<void> sendMessage(
      String chatRoomId, String sender, String text, UserModel user, String type) async {
    try {
      emit(state.copyWith(chatStatus: ChatStatus.loading));
      await _chatRepository.sendMessage(chatRoomId, sender, text, user, type);
      emit(state.copyWith(chatStatus: ChatStatus.success));
    } catch (e) {
      emit(state.copyWith(chatStatus: ChatStatus.fail));
      LogUtil.error("Send message failed", error: e);
    }
  }

  Future<void> updateReadStatus(
      String userId, String roomId, String messageId) async {
    try {
      await _chatRepository.updateReadStatus(userId, roomId, messageId);
    } catch (e) {
      LogUtil.error("Update message read failed", error: e);
    }
  }
}
