import 'package:pma_dclv/data/data_source/remote/user_remote.dart';

import '../models/user/user_model.dart';

class UserRepository {
  late final UserRemoteSource _userRemoteSource;

  UserRepository._internal() {
    _userRemoteSource = UserRemoteSource();
  }

  static final _instance = UserRepository._internal();

  factory UserRepository.instance() => _instance;

  Stream<List<UserModel>> getUsersFromWorkspace(String workspaceId) async* {
    final Stream<List<UserModel>> userStream =
        _userRemoteSource.getUsersFromWorkspace(workspaceId);
    await for (final List<UserModel> users in userStream) {
      yield users;
    }
  }

  Stream<UserModel> getUserFromUid(String userUid) async* {
    yield* _userRemoteSource.getUserFromUid(userUid);
  }
}
