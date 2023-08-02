import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';

abstract class WorkspaceRemote {
  Stream<List<WorkspaceModel>> getWorkspaceFromUser(String userId);
}

class WorkspaceRemoteSource extends WorkspaceRemote {
  @override
  Stream<List<WorkspaceModel>> getWorkspaceFromUser(String userId) {
    final StreamController<List<WorkspaceModel>> controller =
        StreamController<List<WorkspaceModel>>();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
