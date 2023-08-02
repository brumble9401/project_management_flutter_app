part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  failed,
  authenticated,
  registerSuccess,
  registerFail,
}

class AuthState extends Equatable {
  late final String? username;
  late final String? password;
  late final AuthStatus? authStatus;
  late final String? errorMessage;

  AuthState({
    this.username,
    this.password,
    this.authStatus,
    this.errorMessage,
  });

  AuthState.initial() {
    username = "";
    password = "";
    authStatus = AuthStatus.initial;
    errorMessage = "";
  }

  AuthState copyWith({
    String? username,
    String? password,
    AuthStatus? authStatus,
    String? errorMessage,
  }) {
    return AuthState(
      username: username ?? this.username,
      password: password ?? this.password,
      authStatus: authStatus ?? this.authStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        username,
        password,
        errorMessage,
        authStatus,
      ];
}

class AuthCubitInitial extends AuthState {}
