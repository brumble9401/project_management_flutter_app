import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:pma_dclv/data/repositories/task_repository.dart';
import 'package:pma_dclv/utils/log_util.dart';

import '../../data/models/task/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskState.initial());
  final _taskRepository = TaskRepository.instance();

  Stream<List<TaskModel>> getTaskFromFirestore(
      String userId, String projectId) async* {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      yield* _taskRepository.getTaskFromFirestore(userId, projectId);
      emit(state.copyWith(taskStatus: TaskStatus.success));
      LogUtil.info("Fetch tasks success");
    } catch (e) {
      LogUtil.error("Fetch tasks error: ", error: e);
    }
  }

  Stream<List<TaskModel>> getTaskFromProjectUid(String projectId) async* {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      yield* _taskRepository.getTaskFromProjectUid(projectId);
      emit(state.copyWith(taskStatus: TaskStatus.success));
      LogUtil.info("Fetch tasks success");
    } catch (e) {
      LogUtil.error("Fetch tasks error: ", error: e);
    }
  }

  Stream<TaskModel> getTaskFromUid(String taskUid) async* {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      yield* _taskRepository.getTaskFromUid(taskUid);
      emit(state.copyWith(taskStatus: TaskStatus.success));
      LogUtil.info("Fetch tasks success");
    } catch (e) {
      LogUtil.error("Fetch tasks error: ", error: e);
    }
  }

  Future<String> createTask(Map<String, dynamic> task) async {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      String uid = await _taskRepository.createTask(task);
      emit(state.copyWith(taskStatus: TaskStatus.success));
      LogUtil.info("Create task successfully");
      return uid;
    } catch (e) {
      LogUtil.error("Create task failed", error: e);
      return "";
    }
  }

  Stream<List<TaskModel>> getAllTaskFromFirestore(String userId) async* {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      yield* _taskRepository.getAllTaskFromFirestore(userId);
      emit(state.copyWith(taskStatus: TaskStatus.success));
      LogUtil.info("Fetch tasks success");
    } catch (e) {
      LogUtil.error("Fetch tasks error: ", error: e);
    }
  }

  Stream<List<TaskModel>> getAllTaskFromWorkspace(
      String userUId, String workspaceUid) async* {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      yield* _taskRepository.getAllTaskFromWorkspace(userUId, workspaceUid);
      emit(state.copyWith(taskStatus: TaskStatus.success));
      LogUtil.info("Fetch tasks success");
    } catch (e) {
      LogUtil.error("Fetch tasks error: ", error: e);
    }
  }

  Future<void> updateTaskState(String uid, String status) async {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(uid)
          .update({'state': status});
      emit(state.copyWith(taskStatus: TaskStatus.success));
      LogUtil.info("Update tasks success");
    } catch (e) {
      LogUtil.error("Update tasks error: ", error: e);
    }
  }

  Future<void> addUser(List<String> uids, String taskUid) async {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskUid)
          .update({'users_id': FieldValue.arrayUnion(uids)});
      emit(state.copyWith(taskStatus: TaskStatus.success));
      LogUtil.info("Add users to task success");
    } catch (e) {
      LogUtil.error("Add users task error: ", error: e);
    }
  }

  Future<void> updateDescription(
      QuillController controller, String taskUid) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskUid).update({
        'description': jsonEncode(controller.document.toDelta().toJson()),
      });
      print('Text updated successfully.');
    } catch (e) {
      print('Error updating text: $e');
    }
  }

  Future<void> deleteTask(String taskUid) async {
    try {
      emit(state.copyWith(taskStatus: TaskStatus.loading));
      // Get a reference to the document you want to delete
      final documentReference =
          FirebaseFirestore.instance.collection('tasks').doc(taskUid);

      // Delete the document
      await documentReference.delete();
      emit(state.copyWith(taskStatus: TaskStatus.success));
      print('Document deleted successfully.');
    } catch (e) {
      emit(state.copyWith(taskStatus: TaskStatus.fail));
      print('Error deleting document: $e');
      emit(state.copyWith(taskStatus: TaskStatus.initial));
    }
  }
}
