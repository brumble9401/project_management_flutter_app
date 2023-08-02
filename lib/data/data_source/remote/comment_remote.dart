import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pma_dclv/data/models/comment/comment_model.dart';

abstract class CommentRemote {
  Future<void> createTaskComment(
      String userUid, String taskUid, String content);

  Future<void> createProjectComment(
      String userUid, String projectUid, String content);

  Stream<List<CommentModel>> getTaskComment(String taskUid);

  Stream<List<CommentModel>> getProjectComment(String projectUid);
}

class CommentRemoteSource extends CommentRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createTaskComment(
      String userUid, String taskUid, String content) async {
    try {
      final CollectionReference<Map<String, dynamic>> taskRef =
          FirebaseFirestore.instance.collection('comments');

      await taskRef.add({
        'userUid': userUid,
        'taskUid': taskUid,
        'projectUid': '',
        'content': content,
        'created_date': Timestamp.fromDate(DateTime.now()),
      });
      print('New project created successfully}!');
    } catch (e) {
      print('Error creating project: $e');
    }
  }

  @override
  Future<void> createProjectComment(
      String userUid, String projectUid, String content) async {
    try {
      final CollectionReference<Map<String, dynamic>> taskRef =
          FirebaseFirestore.instance.collection('comments');

      await taskRef.add({
        'userUid': userUid,
        'taskUid': '',
        'projectUid': projectUid,
        'content': content,
        'created_date': Timestamp.fromDate(DateTime.now()),
      });
      print('New project created successfully}!');
    } catch (e) {
      print('Error creating project: $e');
    }
  }

  @override
  Stream<List<CommentModel>> getTaskComment(String taskUid) {
    final StreamController<List<CommentModel>> controller =
        StreamController<List<CommentModel>>();

    try {
      final Query query = _firestore
          .collection('comments')
          .where('taskUid', isEqualTo: taskUid);

      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<CommentModel> comments = querySnapshot.docs.map((doc) {
          return CommentModel(
            uid: doc.id,
            content: doc['content'] ?? '',
            userUid: doc['userUid'] ?? '',
            taskUid: doc['taskUid'] ?? '',
            projectUid: doc['projectUid'] ?? '',
            createdDate: (doc['created_date'] as Timestamp).toDate(),
          );
        }).toList();
        controller.add(comments);
      });
      controller.onCancel = () {
        subscription.cancel();
      };
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }

  @override
  Stream<List<CommentModel>> getProjectComment(String projectUid) {
    final StreamController<List<CommentModel>> controller =
        StreamController<List<CommentModel>>();

    try {
      final Query query = _firestore
          .collection('comments')
          .where('projectUid', isEqualTo: projectUid);

      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<CommentModel> comments = querySnapshot.docs.map((doc) {
          return CommentModel(
            uid: doc.id,
            content: doc['content'] ?? '',
            userUid: doc['userUid'] ?? '',
            taskUid: doc['taskUid'] ?? '',
            projectUid: doc['projectUid'] ?? '',
            createdDate: (doc['created_date'] as Timestamp).toDate(),
          );
        }).toList();
        controller.add(comments);
      });
      controller.onCancel = () {
        subscription.cancel();
      };
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}
