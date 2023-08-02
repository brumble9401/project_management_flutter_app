import 'package:pma_dclv/data/data_source/remote/comment_remote.dart';
import 'package:pma_dclv/data/models/comment/comment_model.dart';

class CommentRepository {
  late final CommentRemoteSource _commentRemoteSource;

  CommentRepository._internal() {
    _commentRemoteSource = CommentRemoteSource();
  }

  static final _instance = CommentRepository._internal();

  factory CommentRepository.instance() => _instance;

  Future<void> createTaskComment(
      String userUid, String taskUid, String content) async {
    await _commentRemoteSource.createTaskComment(userUid, taskUid, content);
  }

  Stream<List<CommentModel>> getTaskComment(String taskUid) async* {
    final Stream<List<CommentModel>> commentStream =
        _commentRemoteSource.getTaskComment(taskUid);
    await for (final List<CommentModel> comments in commentStream) {
      yield comments;
    }
  }

  Future<void> createProjectComment(
      String userUid, String projectUid, String content) async {
    await _commentRemoteSource.createProjectComment(
        userUid, projectUid, content);
  }

  Stream<List<CommentModel>> getProjectComment(String projectUid) async* {
    final Stream<List<CommentModel>> commentStream =
        _commentRemoteSource.getProjectComment(projectUid);
    await for (final List<CommentModel> comments in commentStream) {
      yield comments;
    }
  }
}
