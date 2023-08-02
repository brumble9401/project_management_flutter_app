import 'package:pma_dclv/data/data_source/remote/workspace_remote.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';

class WorkspaceRepository {
  late final WorkspaceRemoteSource _workspaceRemoteSource;

  WorkspaceRepository._internal() {
    _workspaceRemoteSource = WorkspaceRemoteSource();
  }

  static final _instance = WorkspaceRepository._internal();

  factory WorkspaceRepository.instance() => _instance;

  Stream<List<WorkspaceModel>> getWorkspaceFromUser(String userId) async* {
    final Stream<List<WorkspaceModel>> workspaceStream =
        _workspaceRemoteSource.getWorkspaceFromUser(userId);
    await for (final List<WorkspaceModel> workspaces in workspaceStream) {
      yield workspaces;
    }
  }
}
