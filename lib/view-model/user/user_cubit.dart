import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pma_dclv/data/repositories/user_repository.dart';
import 'package:pma_dclv/utils/Notification_Services.dart';
import 'package:pma_dclv/utils/user_adapter.dart';

import '../../data/models/user/user_model.dart';
import '../../utils/log_util.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState.initial());

  final _userRepository = UserRepository.instance();

  Stream<List<UserModel>> getUsersFromWorkspace(String workspaceId) async* {
    try {
      emit(state.copyWith(userStatus: UserStatus.loading));
      yield* _userRepository.getUsersFromWorkspace(workspaceId);
      emit(state.copyWith(userStatus: UserStatus.success));
      LogUtil.info("Fetch users success");
    } catch (e) {
      LogUtil.error("Fetch users error: ", error: e);
    }
  }

  Stream<UserModel> getUserFromUid(String userUid) async* {
    try {
      emit(state.copyWith(userStatus: UserStatus.loading));
      yield* _userRepository.getUserFromUid(userUid);
      emit(state.copyWith(userStatus: UserStatus.success));
      LogUtil.info("Fetch users success");
    } catch (e) {
      LogUtil.error("Fetch users error: ", error: e);
    }
  }

  Stream<List<UserModel>> getListofUserFromUid(List<String> userUids) async* {
    List<UserModel> users = [];
    try {
      for (String uid in userUids) {
        Stream<UserModel> userStream = getUserFromUid(uid);
        UserModel? user = await userStream.first;
        users.add(user);
      }
      yield users;
    } catch (e) {
      print(e);
      yield users;
    }
  }

  Future<void> updatePushToken(String userUid) async {
    try {
      final String token = await NotificationServices().getToken();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .update({'pushToken': token});
      print('Token updated successfully.');
    } catch (e) {
      print('Error Token updated : $e');
    }
  }
}
