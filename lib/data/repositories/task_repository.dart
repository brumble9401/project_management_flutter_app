import 'package:pma_dclv/data/data_source/remote/task_remote.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';

class TaskRepository {
  late final TaskRemoteSource _taskRemoteSource;

  TaskRepository._internal() {
    _taskRemoteSource = TaskRemoteSource();
  }

  static final _instance = TaskRepository._internal();

  factory TaskRepository.instance() => _instance;

  Stream<List<TaskModel>> getTaskFromFirestore(
      String userIds, String projectId) async* {
    final Stream<List<TaskModel>> taskStream =
        _taskRemoteSource.getTaskFromFirestore(userIds, projectId);
    await for (final List<TaskModel> tasks in taskStream) {
      yield tasks;
    }
  }

  Stream<List<TaskModel>> getTaskFromProjectUid(String projectId) async* {
    final Stream<List<TaskModel>> taskStream =
        _taskRemoteSource.getTaskFromProjectUid(projectId);
    await for (final List<TaskModel> tasks in taskStream) {
      yield tasks;
    }
  }

  Stream<TaskModel> getTaskFromUid(String taskUid) async* {
    final Stream<TaskModel> taskStream =
        _taskRemoteSource.getTaskFromUid(taskUid);
    await for (final TaskModel task in taskStream) {
      yield task;
    }
  }

  Stream<List<TaskModel>> getAllTaskFromFirestore(String userIds) async* {
    final Stream<List<TaskModel>> taskStream =
        _taskRemoteSource.getAllTaskFromFirestore(userIds);
    await for (final List<TaskModel> tasks in taskStream) {
      yield tasks;
    }
  }

  Stream<List<TaskModel>> getAllTaskFromWorkspace(
      String userUid, String workspaceUid) async* {
    final Stream<List<TaskModel>> taskStream =
        _taskRemoteSource.getAllTaskFromWorkspace(userUid, workspaceUid);
    await for (final List<TaskModel> tasks in taskStream) {
      yield tasks;
    }
  }

  Future<String> createTask(Map<String, dynamic> task) async {
    return await _taskRemoteSource.createTask(task);
  }
}
