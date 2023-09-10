import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
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

  Future<String> createProject(Map<String, dynamic> project) async {
    try {
      emit(state.copyWith(projectStatus: ProjectStatus.loading));
      String uid = await _projectRepository.createProject(project);
      emit(state.copyWith(projectStatus: ProjectStatus.success));
      LogUtil.info("Create task successfully");
      return uid;
    } catch (e) {
      LogUtil.error("Create task failed", error: e);
      return "";
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

  Future<void> updateDescription(QuillController controller, String projectUid) async {
    try {
      await FirebaseFirestore.instance.collection('projects').doc(projectUid).update({
        'description': jsonEncode(controller.document.toDelta().toJson()),
      });
      print('Text updated successfully.');
    } catch (e) {
      print('Error updating text: $e');
    }
  }
}
