import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pma_dclv/data/repositories/workspace_repository.dart';

import '../../data/models/workspaces/workspace.dart';
import '../../utils/log_util.dart';

part 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit() : super(WorkspaceState.initial());

  final _workspaceRepository = WorkspaceRepository.instance();

  Stream<List<WorkspaceModel>> getWorkspaceFromUser(String userId) async* {
    try {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.loading));
      yield* _workspaceRepository.getWorkspaceFromUser(userId);
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.success));
      LogUtil.info("Fetch workspace success");
    } catch (e) {
      LogUtil.error("Fetch workspace error: ", error: e);
    }
  }

  Stream<WorkspaceModel> getWorkspaceFromUid(String uid) async* {
    try {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.loading));
      yield* _workspaceRepository.getWorkspaceFromUid(uid);
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.success));
      LogUtil.info("Fetch workspace success");
    } catch (e) {
      LogUtil.error("Fetch workspace error: ", error: e);
    }
  }

  Future<String> createWorkspace(
      Map<String, dynamic> obj, String userUid) async {
    try {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.loading));

      if (obj['workspace_name'].toString().isEmpty) {
        throw Exception("Please provide workspace name");
      }

      final DocumentReference<Map<String, dynamic>> newWorkspace =
          await FirebaseFirestore.instance.collection('workspaces').add(obj);

      emit(state.copyWith(workspaceStatus: WorkspaceStatus.success));
      LogUtil.info("Create workspace successfully: ");
      return newWorkspace.id;
    } catch (e) {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.fail));
      LogUtil.error("Create workspace error: ", error: e);
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.initial));
      return "";
    }
  }

  Future<void> updateWorkspaceUidFromUser(
      String userUid, String workspaceUid) async {
    FirebaseFirestore.instance.collection('users').doc(userUid).update({
      'workspace_id': FieldValue.arrayUnion([workspaceUid])
    });
  }
}
