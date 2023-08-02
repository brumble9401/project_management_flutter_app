import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pma_dclv/data/repositories/comment_repository.dart';

import '../../data/models/comment/comment_model.dart';
import '../../utils/log_util.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentState.initial());

  final _commentRepository = CommentRepository.instance();

  Future<void> createTaskComment(
      String taskUid, String userUid, String content) async {
    try {
      emit(state.copyWith(commentStatus: CommentStatus.loading));
      await _commentRepository.createTaskComment(userUid, taskUid, content);
      emit(state.copyWith(commentStatus: CommentStatus.success));
      LogUtil.info("Create comment successfully");
    } catch (e) {
      LogUtil.error("Create comment fail", error: e);
    }
  }

  Stream<List<CommentModel>> getTaskComment(String taskUid) async* {
    try {
      emit(state.copyWith(commentStatus: CommentStatus.loading));
      yield* _commentRepository.getTaskComment(taskUid);
      emit(state.copyWith(commentStatus: CommentStatus.success));
      LogUtil.info("Fetch comments success");
    } catch (e) {
      LogUtil.error("Fetch comments error: ", error: e);
    }
  }

  Future<void> createProjectComment(
      String projectUid, String userUid, String content) async {
    try {
      emit(state.copyWith(commentStatus: CommentStatus.loading));
      await _commentRepository.createProjectComment(
          userUid, projectUid, content);
      emit(state.copyWith(commentStatus: CommentStatus.success));
      LogUtil.info("Create comment successfully");
    } catch (e) {
      LogUtil.error("Create comment fail", error: e);
    }
  }

  Stream<List<CommentModel>> getProjectComment(String projectUid) async* {
    try {
      emit(state.copyWith(commentStatus: CommentStatus.loading));
      yield* _commentRepository.getProjectComment(projectUid);
      emit(state.copyWith(commentStatus: CommentStatus.success));
      LogUtil.info("Fetch comments success");
    } catch (e) {
      LogUtil.error("Fetch comments error: ", error: e);
    }
  }
}
