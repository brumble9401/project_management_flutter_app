import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pma_dclv/data/repositories/project_repository.dart';
import 'package:pma_dclv/utils/log_util.dart';

import '../../data/models/project/project_model.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(ProjectState.initial());
  final _projectRepository = ProjectRepository.instance();

  Stream<List<ProjectModel>> getProjectFromFirestore(String user_id) async* {
    try {
      emit(state.copyWith(projectStatus: ProjectStatus.loading));
      yield* _projectRepository.getProjectFromFirestore(user_id);
      emit(state.copyWith(projectStatus: ProjectStatus.success));
      LogUtil.info("Fetch project success");
    } catch (e) {
      LogUtil.error("Fetch project error: ", error: e);
    }
  }

  Stream<List<ProjectModel>> getProjectFromWorkspaceUid(
      String userUid, String workspaceUid) async* {
    try {
      emit(state.copyWith(projectStatus: ProjectStatus.loading));
      yield* _projectRepository.getProjectFromWorkspaceUid(
          userUid, workspaceUid);
      emit(state.copyWith(projectStatus: ProjectStatus.success));
      LogUtil.info("Fetch project success");
    } catch (e) {
      LogUtil.error("Fetch project error: ", error: e);
    }
  }

  Stream<ProjectModel> getProjectFromUid(String projectUid) async* {
    try {
      emit(state.copyWith(projectStatus: ProjectStatus.loading));
      yield* _projectRepository.getProjectFromUid(projectUid);
      emit(state.copyWith(projectStatus: ProjectStatus.success));
      LogUtil.info("Fetch project success");
    } catch (e) {
      LogUtil.error("Fetch project error: ", error: e);
    }
  }

  Future<void> addUserToCollection(
      List<String> userIds, String projectId) async {
    try {
      _projectRepository.addUserToCollection(userIds, projectId);
      print('User added successfully');
    } catch (e) {
      print('Error adding user: $e');
    }
  }
}
