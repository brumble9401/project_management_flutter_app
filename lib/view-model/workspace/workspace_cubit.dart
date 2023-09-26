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

  Future<void> deleteUserFromWorkspace(
    String workspaceUid,
    String userUid,
  ) async {
    try {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.loading));

      final FirebaseFirestore documentReference = FirebaseFirestore.instance;
      await documentReference
          .collection('workspaces')
          .doc(workspaceUid)
          .update({
        'users_id': FieldValue.arrayRemove([userUid])
      }).then(
        (value) async {
          final DocumentSnapshot workspaceSnap = await FirebaseFirestore
              .instance
              .collection('users')
              .doc(userUid)
              .get();
          final List<dynamic> workspaceList = workspaceSnap.get('workspace_id');
          workspaceList.remove(workspaceUid);

          await documentReference.collection('users').doc(userUid).update({
            'workspace_id': FieldValue.arrayRemove([workspaceUid])
          });
        },
      );

      emit(state.copyWith(workspaceStatus: WorkspaceStatus.success));
      LogUtil.info("Delete user from workspace successfully: ");
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.initial));
    } catch (e) {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.fail));
      LogUtil.error("Delete user from workspace error: ", error: e);
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.initial));
    }
  }

  Future<void> updateLeaderInWorkspace(
    String workspaceUid,
    String userUid,
  ) async {
    try {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.loading));

      await FirebaseFirestore.instance
          .collection('workspaces')
          .doc(workspaceUid)
          .update({
        'leaders_id': FieldValue.arrayUnion([userUid])
      });

      emit(state.copyWith(workspaceStatus: WorkspaceStatus.success));
      LogUtil.info("Promote leader in workspace successfully: ");
    } catch (e) {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.fail));
      LogUtil.error("Promote leader in workspace error: ", error: e);
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.initial));
    }
  }

  Future<String> deleteWorkspace(String workspaceUid) async {
    try {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.loading));

      final batch = FirebaseFirestore.instance.batch();

      // 1. Delete the workspace document
      final workspaceRef =
          FirebaseFirestore.instance.collection('workspaces').doc(workspaceUid);
      batch.delete(workspaceRef);

      // 2. Delete all projects in the same workspace
      final projectsQuery = FirebaseFirestore.instance
          .collection('projects')
          .where('workspace_id', isEqualTo: workspaceUid);

      final projectDocs = await projectsQuery.get();
      for (final projectDoc in projectDocs.docs) {
        final projectRef = FirebaseFirestore.instance
            .collection('projects')
            .doc(projectDoc.id);
        batch.delete(projectRef);
      }

      // 3. Delete all tasks in the same workspace
      final tasksQuery = FirebaseFirestore.instance
          .collection('tasks')
          .where('workspace_id', isEqualTo: workspaceUid);

      final taskDocs = await tasksQuery.get();
      for (final taskDoc in taskDocs.docs) {
        final taskRef =
            FirebaseFirestore.instance.collection('tasks').doc(taskDoc.id);
        batch.delete(taskRef);
      }

      // Commit the batched write
      await batch.commit();

      emit(state.copyWith(workspaceStatus: WorkspaceStatus.success));

      return 'success';
    } catch (e) {
      emit(state.copyWith(workspaceStatus: WorkspaceStatus.fail));
      LogUtil.error("Delete workspace error: ", error: e);
      return 'fail';
    }
  }

  Future<bool> checkLeader(String workspaceUid, String userUid) async {
    try {
      final workspaceDoc = await FirebaseFirestore.instance
          .collection('workspaces')
          .doc(workspaceUid)
          .get();
      print(workspaceDoc);
      if (workspaceDoc.exists) {
        final List<dynamic> leaderIds = workspaceDoc.data()!['leaders_id'];

        // Check if userUid is in the leader_ids list
        if (leaderIds.contains(userUid)) {
          return true;
        }
      }

      return false; // UserUid is not in the leader_ids list or workspace doesn't exist.
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }
}
