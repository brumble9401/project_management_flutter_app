part of 'chat_cubit.dart';

enum ChatStatus { loading, initial, success, fail }

class ChatState extends Equatable {
  late final ChatStatus? chatStatus;
  late final String? errorMessage;
  late final List<dynamic>? chats;

  ChatState({
    this.errorMessage,
    this.chatStatus,
    this.chats,
  });

  ChatState.initial() {
    errorMessage = "";
    chatStatus = ChatStatus.initial;
    chats = [];
  }

  ChatState copyWith({
    String? errorMessage,
    ChatStatus? chatStatus,
    List<dynamic>? chats,
  }) {
    return ChatState(
      errorMessage: errorMessage ?? this.errorMessage,
      chatStatus: chatStatus ?? this.chatStatus,
      chats: chats ?? this.chats,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        chats,
        chatStatus,
      ];
}
