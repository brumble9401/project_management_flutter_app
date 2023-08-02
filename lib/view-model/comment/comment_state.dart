part of 'comment_cubit.dart';

enum CommentStatus { loading, initial, success, fail }

class CommentState extends Equatable {
  late final CommentStatus? commentStatus;
  late final String? errorMessage;
  late final List<CommentModel>? comment;

  CommentState({
    this.errorMessage,
    this.commentStatus,
    this.comment,
  });

  CommentState.initial() {
    errorMessage = "";
    commentStatus = CommentStatus.initial;
    comment = [];
  }

  CommentState copyWith({
    String? errorMessage,
    CommentStatus? commentStatus,
    List<CommentModel>? comment,
  }) {
    return CommentState(
      errorMessage: errorMessage ?? this.errorMessage,
      commentStatus: commentStatus ?? this.commentStatus,
      comment: comment ?? this.comment,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        comment,
        commentStatus,
      ];
}
