import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/project/project_model.dart';

abstract class ProjectRemote {
  Stream<List<ProjectModel>> getProjectFromFirestore(String user_id);

  Stream<ProjectModel?> getProjectFromUid(String projectUid);

  Future<void> addUserToCollection(List<String> userIds, String projectId);
}

class ProjectRemoteSource extends ProjectRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ProjectModel>> getProjectFromFirestore(String user_id) {
    final StreamController<List<ProjectModel>> controller =
        StreamController<List<ProjectModel>>();

    try {
      final Query query = _firestore
          .collection('projects')
          .where('users_id', arrayContains: user_id);

      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<ProjectModel> projects = querySnapshot.docs.map((doc) {
          return ProjectModel(
            id: doc.id,
            name: doc['project_name'] ?? '',
            description: doc['description'] ?? '',
            createdDate: (doc['created_date'] as Timestamp).toDate(),
            deadline: (doc['deadline'] as Timestamp).toDate(),
            finishedTime: (doc['finished_time'] as Timestamp).toDate(),
            state: doc['state'] ?? '',
            userIds: List<String>.from(doc['users_id']),
            workspaceId: doc['workspace_id'] ?? '',
          );
        }).toList();
        controller.add(projects);
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
  Stream<ProjectModel> getProjectFromUid(String projectUid) {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('projects').doc(projectUid);

      return docRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          return ProjectModel(
            id: snapshot.id,
            name: snapshot['project_name'] ?? '',
            description: snapshot['description'] ?? '',
            createdDate: (snapshot['created_date'] as Timestamp).toDate(),
            deadline: (snapshot['deadline'] as Timestamp).toDate(),
            finishedTime: (snapshot['finished_time'] as Timestamp).toDate(),
            state: snapshot['state'] ?? '',
            userIds: List<String>.from(snapshot['users_id'] ?? []),
            workspaceId: snapshot['workspace_id'] ?? '',
          );
        } else {
          return ProjectModel();
        }
      });
    } catch (e) {
      print('Error fetching project: $e');
      return Stream.error(e);
    }
  }

  @override
  Future<void> addUserToCollection(
      List<String> userIds, String projectId) async {
    try {
      await _firestore
          .collection('projects')
          .doc(projectId)
          .update({'users_id': FieldValue.arrayUnion(userIds)});
      print('User added successfully');
    } catch (e) {
      print('Error adding user: $e');
    }
  }
}
