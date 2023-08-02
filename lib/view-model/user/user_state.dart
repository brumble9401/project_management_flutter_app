part of 'user_cubit.dart';

enum UserStatus { loading, initial, success, fail }

class UserState extends Equatable {
  late final UserStatus? userStatus;
  late final String? errorMessage;
  late final List<UserModel>? users;

  UserState({
    this.errorMessage,
    this.userStatus,
    this.users,
  });

  UserState.initial() {
    errorMessage = "";
    userStatus = UserStatus.initial;
    users = [];
  }

  UserState copyWith({
    String? errorMessage,
    UserStatus? userStatus,
    List<UserModel>? users,
  }) {
    return UserState(
      errorMessage: errorMessage ?? this.errorMessage,
      userStatus: userStatus ?? this.userStatus,
      users: users ?? this.users,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        errorMessage,
        users,
        userStatus,
      ];
}
