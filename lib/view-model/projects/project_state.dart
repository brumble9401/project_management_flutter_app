part of 'project_cubit.dart';

enum ProjectStatus { initial, loading, success, failed }

class ProjectState extends Equatable {
  late final ProjectStatus? projectStatus;
  late final String? errorMessage;
  late final List<ProjectModel>? projects;

  ProjectState({
    this.errorMessage,
    this.projectStatus,
    this.projects,
  });

  ProjectState.initial() {
    errorMessage = "";
    projectStatus = ProjectStatus.initial;
    projects = [];
  }

  ProjectState copyWith({
    String? errorMessage,
    ProjectStatus? projectStatus,
    List<ProjectModel>? projects,
  }) {
    return ProjectState(
      errorMessage: errorMessage ?? this.errorMessage,
      projectStatus: projectStatus ?? this.projectStatus,
      projects: projects ?? this.projects,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        projects,
        projectStatus,
      ];
}
