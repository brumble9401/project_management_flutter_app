import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';

abstract class WorkspaceRemote {
  Stream<List<WorkspaceModel>> getWorkspaceFromUser(String userId);

  Stream<WorkspaceModel> getWorkspaceFromUid(String uid);
}

class WorkspaceRemoteSource extends WorkspaceRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<WorkspaceModel>> getWorkspaceFromUser(String userId) {
    final StreamController<List<WorkspaceModel>> controller =
        StreamController<List<WorkspaceModel>>();

    try {
      final Query query = _firestore
          .collection('workspaces')
          .where('users_id', arrayContains: userId);

      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<WorkspaceModel> workspaces = querySnapshot.docs.map((doc) {
          return WorkspaceModel(
            uid: doc.id,
            workspaceLeaderId: List<String>.from(doc['leaders_id']),
            userIds: List<String>.from(doc['users_id']),
            workspaceName: doc['workspace_name'] ?? '',
          );
        }).toList();
        controller.add(workspaces);
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
  Stream<WorkspaceModel> getWorkspaceFromUid(String uid) {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('workspaces').doc(uid);

      return docRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          print(snapshot);
          return WorkspaceModel(
            uid: snapshot.id,
            workspaceName: snapshot['workspace_name'] ?? '',
            userIds: List<String>.from(snapshot['users_id'] ?? []),
            workspaceLeaderId: List<String>.from(snapshot['leaders_id'] ?? []),
          );
        } else {
          return WorkspaceModel();
        }
      });
    } catch (e) {
      print('Error fetching project: $e');
      return Stream.error(e);
    }
  }
}
