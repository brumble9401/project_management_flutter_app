part of 'workspace_cubit.dart';

enum WorkspaceStatus { loading, initial, success, fail }

class WorkspaceState extends Equatable {
  late final WorkspaceStatus? workspaceStatus;
  late final String? errorMessage;
  late final List<WorkspaceModel>? workspaces;

  WorkspaceState({
    this.errorMessage,
    this.workspaceStatus,
    this.workspaces,
  });

  WorkspaceState.initial() {
    errorMessage = "";
    workspaceStatus = WorkspaceStatus.initial;
    workspaces = [];
  }

  WorkspaceState copyWith({
    String? errorMessage,
    WorkspaceStatus? workspaceStatus,
    List<WorkspaceModel>? workspaces,
  }) {
    return WorkspaceState(
      errorMessage: errorMessage ?? this.errorMessage,
      workspaceStatus: workspaceStatus ?? this.workspaceStatus,
      workspaces: workspaces ?? this.workspaces,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        workspaces,
        workspaceStatus,
      ];
}
