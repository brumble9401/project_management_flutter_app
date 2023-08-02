part of 'task_cubit.dart';

enum TaskStatus { loading, initial, success, fail }

class TaskState extends Equatable {
  late final TaskStatus? taskStatus;
  late final String? errorMessage;
  late final List<TaskModel>? tasks;

  TaskState({
    this.errorMessage,
    this.taskStatus,
    this.tasks,
  });

  TaskState.initial() {
    errorMessage = "";
    taskStatus = TaskStatus.initial;
    tasks = [];
  }

  TaskState copyWith({
    String? errorMessage,
    TaskStatus? taskStatus,
    List<TaskModel>? tasks,
  }) {
    return TaskState(
      errorMessage: errorMessage ?? this.errorMessage,
      taskStatus: taskStatus ?? this.taskStatus,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        tasks,
        taskStatus,
      ];
}
