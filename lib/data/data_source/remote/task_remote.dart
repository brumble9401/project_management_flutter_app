import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';

abstract class TaskRemote {
  Stream<List<TaskModel>> getTaskFromFirestore(String userId, String projectId);

  Stream<List<TaskModel>> getTaskFromProjectUid(String projectId);

  Stream<List<TaskModel>> getAllTaskFromFirestore(String userId);

  Stream<TaskModel> getTaskFromUid(String taskUid);

  Stream<List<TaskModel>> getAllTaskFromWorkspace(
      String userUid, String workspaceUid);

  Future<String> createTask(Map<String, dynamic> object);
}

class TaskRemoteSource extends TaskRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<TaskModel>> getTaskFromFirestore(
      String userId, String projectId) {
    final StreamController<List<TaskModel>> controller =
        StreamController<List<TaskModel>>();
    try {
      final Query query = _firestore
          .collection('tasks')
          .where('users_id', arrayContains: userId)
          .where('project_id', isEqualTo: projectId);
      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<TaskModel> projects = querySnapshot.docs.map((doc) {
          return TaskModel(
            id: doc.id,
            name: doc['task_name'] ?? '',
            description: doc['description'] ?? '',
            createdDate: (doc['created_date'] as Timestamp).toDate(),
            deadline: (doc['deadline'] as Timestamp).toDate(),
            finishedTime: (doc['finished_time'] as Timestamp).toDate(),
            state: doc['state'] ?? '',
            userIds: List<String>.from(doc['users_id']),
            workspaceId: doc['workspace_id'] ?? '',
            projectUid: doc['project_id'] ?? '',
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
  Stream<List<TaskModel>> getTaskFromProjectUid(String projectId) {
    final StreamController<List<TaskModel>> controller =
        StreamController<List<TaskModel>>();
    try {
      final Query query = _firestore
          .collection('tasks')
          .where('project_id', isEqualTo: projectId);
      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<TaskModel> projects = querySnapshot.docs.map((doc) {
          return TaskModel(
            id: doc.id,
            name: doc['task_name'] ?? '',
            description: doc['description'] ?? '',
            createdDate: (doc['created_date'] as Timestamp).toDate(),
            deadline: (doc['deadline'] as Timestamp).toDate(),
            finishedTime: (doc['finished_time'] as Timestamp).toDate(),
            state: doc['state'] ?? '',
            userIds: List<String>.from(doc['users_id']),
            workspaceId: doc['workspace_id'] ?? '',
            projectUid: doc['project_id'] ?? '',
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
  Stream<List<TaskModel>> getAllTaskFromFirestore(String userId) {
    final StreamController<List<TaskModel>> controller =
        StreamController<List<TaskModel>>();
    try {
      final Query query = _firestore
          .collection('tasks')
          .where('users_id', arrayContains: userId);
      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<TaskModel> tasks = querySnapshot.docs.map((doc) {
          return TaskModel(
            id: doc.id,
            name: doc['task_name'] ?? '',
            description: doc['description'] ?? '',
            createdDate: (doc['created_date'] as Timestamp).toDate(),
            deadline: (doc['deadline'] as Timestamp).toDate(),
            finishedTime: (doc['finished_time'] as Timestamp).toDate(),
            state: doc['state'] ?? '',
            userIds: List<String>.from(doc['users_id']),
            workspaceId: doc['workspace_id'] ?? '',
            projectUid: doc['project_id'] ?? '',
          );
        }).toList();
        controller.add(tasks);
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
  Stream<List<TaskModel>> getAllTaskFromWorkspace(
      String userUid, String workspaceUid) {
    final StreamController<List<TaskModel>> controller =
        StreamController<List<TaskModel>>();
    try {
      final Query query = _firestore
          .collection('tasks')
          .where('users_id', arrayContains: userUid)
          .where('workspace_id', isEqualTo: workspaceUid);
      final StreamSubscription<QuerySnapshot> subscription =
          query.snapshots().listen((querySnapshot) {
        final List<TaskModel> tasks = querySnapshot.docs.map((doc) {
          return TaskModel(
            id: doc.id,
            name: doc['task_name'] ?? '',
            description: doc['description'] ?? '',
            createdDate: (doc['created_date'] as Timestamp).toDate(),
            deadline: (doc['deadline'] as Timestamp).toDate(),
            finishedTime: (doc['finished_time'] as Timestamp).toDate(),
            state: doc['state'] ?? '',
            userIds: List<String>.from(doc['users_id']),
            workspaceId: doc['workspace_id'] ?? '',
            projectUid: doc['project_id'] ?? '',
          );
        }).toList();
        controller.add(tasks);
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
  Stream<TaskModel> getTaskFromUid(String taskUid) {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('tasks').doc(taskUid);
      return docRef.snapshots().map((snapshot) {
        if (snapshot.exists) {
          return TaskModel(
            id: snapshot.id,
            name: snapshot['task_name'] ?? '',
            description: snapshot['description'] ?? '',
            createdDate: (snapshot['created_date'] as Timestamp).toDate(),
            deadline: (snapshot['deadline'] as Timestamp).toDate(),
            finishedTime: (snapshot['finished_time'] as Timestamp).toDate(),
            state: snapshot['state'] ?? '',
            userIds: List<String>.from(snapshot['users_id']),
            workspaceId: snapshot['workspace_id'] ?? '',
            projectUid: snapshot['project_id'] ?? '',
          );
        } else {
          return TaskModel();
        }
      });
    } catch (e) {
      print('Error fetching task: $e');
      return Stream.error(e);
    }
  }

  @override
  Future<String> createTask(Map<String, dynamic> task) async {
    try {
      final CollectionReference<Map<String, dynamic>> taskRef =
          FirebaseFirestore.instance.collection('tasks');
      final DocumentReference<Map<String, dynamic>> newTaskRef =
          await taskRef.add(task);
      print('New project created successfully}!');
      print(newTaskRef.id);
      return newTaskRef.id;
    } catch (e) {
      print('Error creating project: $e');
      return "";
    }
  }
}
