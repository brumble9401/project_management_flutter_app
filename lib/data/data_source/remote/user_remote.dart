import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';

abstract class UserRemote {
  Stream<List<UserModel>> getUsersFromWorkspace(String workspaceId);
  Stream<UserModel> getUserFromUid(String userUid);
}

class UserRemoteSource extends UserRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<UserModel>> getUsersFromWorkspace(String workspaceId) {
    final StreamController<List<UserModel>> controller =
        StreamController<List<UserModel>>();

    try {
      final Query query = _firestore
          .collection('users')
          .where('workspace_id', arrayContains: workspaceId);

      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<UserModel> users = querySnapshot.docs.map((doc) {
          return UserModel(
            id: doc.id,
            firstName: doc['first_name'] ?? '',
            lastName: doc['last_name'] ?? '',
            email: doc['email'] ?? '',
            avatar: doc['avatar'] ?? '',
            pushToken: doc['pushToken'] ?? '',
            workspaceIds: List<String>.from(doc['workspace_id']),
          );
        }).toList();
        controller.add(users);
      });
      controller.onCancel = () {
        subscription.cancel();
      };
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }

  Stream<UserModel> getUserFromUid(String userUid) {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('users').doc(userUid);
      return docRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          return UserModel(
            id: snapshot.id,
            firstName: snapshot['first_name'] ?? '',
            lastName: snapshot['last_name'] ?? '',
            email: snapshot['email'] ?? '',
            avatar: snapshot['avatar'] ?? '',
            pushToken: snapshot['pushToken'] ?? '',
            workspaceIds: List<String>.from(snapshot['workspace_id']),
          );
        } else {
          return UserModel();
        }
      });
    } catch (e) {
      print('Error fetching task: $e');
      return Stream.error(e);
    }
  }
}
