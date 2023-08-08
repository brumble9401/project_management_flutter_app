import 'package:pma_dclv/data/data_source/remote/project_remote.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';

class ProjectRepository {
  late final ProjectRemoteSource _projectRemoteSource;

  ProjectRepository._internal() {
    _projectRemoteSource = ProjectRemoteSource();
  }

  static final _instance = ProjectRepository._internal();

  factory ProjectRepository.instance() => _instance;

  Stream<List<ProjectModel>> getProjectFromFirestore(String user_id) async* {
    final Stream<List<ProjectModel>> projectStream =
        _projectRemoteSource.getProjectFromFirestore(user_id);
    await for (final List<ProjectModel> projects in projectStream) {
      yield projects;
    }
  }

  Stream<List<ProjectModel>> getProjectFromWorkspaceUid(
      String userUid, String workspaceUid) async* {
    final Stream<List<ProjectModel>> projectStream =
        _projectRemoteSource.getProjectFromWorkspaceUid(userUid, workspaceUid);
    await for (final List<ProjectModel> projects in projectStream) {
      yield projects;
    }
  }

  Stream<ProjectModel> getProjectFromUid(String projectUid) async* {
    final Stream<ProjectModel> projectStream =
        _projectRemoteSource.getProjectFromUid(projectUid);
    await for (final ProjectModel project in projectStream) {
      yield project;
    }
  }

  Future<void> addUserToCollection(
      List<String> userIds, String projectId) async {
    _projectRemoteSource.addUserToCollection(userIds, projectId);
  }

  Future<String> createProject(Map<String, dynamic> project) async {
    return await _projectRemoteSource.createProject(project);
  }
}
