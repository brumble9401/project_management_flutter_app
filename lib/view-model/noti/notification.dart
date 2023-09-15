import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pma_dclv/data/models/notification/notification_model.dart';

class NotificationCubit extends Cubit<String> {
  NotificationCubit() : super('');

  Stream<List<NotificationModel>> getNotificationHistory(String userUid) async* {
    final StreamController<List<NotificationModel>> controller =
    StreamController<List<NotificationModel>>();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      final Query query = _firestore
          .collection('notifications')
          .where('receiver', isEqualTo: userUid);

      final StreamSubscription<QuerySnapshot> subscription =
      query.snapshots().listen((querySnapshot) {
        final List<NotificationModel> notifications = querySnapshot.docs.map((doc) {
          return NotificationModel(
            uid: doc.id,
            title: doc['title'] ?? '',
            body: doc['body'] ?? '',
            receiver: doc['receiver'] ?? '',
            read: doc['read'],
            payload: Map<String, dynamic>.from(doc['payload']),
            createdDate: (doc['created_date'] as Timestamp).toDate(),
          );
        }).toList();
        controller.add(notifications);
      });
      controller.onCancel = () {
        subscription.cancel();
      };
    } catch (e) {
      controller.addError(e);
    }
    yield* controller.stream;
  }

  Future<void> updateReadStatus(String notiUid) async {
    try{
      await FirebaseFirestore.instance.collection('notifications').doc(notiUid).update({"read": "true"});
      print("Update notificaion status successfully");
    } catch (e) {
      print(e);
    }
  }

}
