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
}
