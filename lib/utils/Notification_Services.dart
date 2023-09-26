import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/utils/local_notification_service.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((event) {
      handleForegroundMessage(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleOnOpenedApp(event);
    });

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> storeNotification(RemoteMessage message) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('notifications').add({
      "title": message.notification!.title,
      "body": message.notification!.body,
      "payload": message.data,
      "receiver": message.data['receiver'],
      "read": "false",
      "created_date": Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<String> getToken() async {
    final FCMToken = await messaging.getToken();
    return FCMToken.toString();
  }

  Future<void> handleForegroundMessage(RemoteMessage message) async {
    print('a');
    print('Title: ${message.notification?.title}');
    print("Body: ${message.notification?.body}");
    print('Payload: ${message.data}');

    LocalNotificationService.display(message);

    await storeNotification(message);
  }

  Future<void> handleOnOpenedApp(RemoteMessage message) async {
    print('b');
    print('Title: ${message.notification?.title}');
    print("Body: ${message.notification?.body}");
    print('Payload: ${message.data}');

    LocalNotificationService.display(message);

    await storeNotification(message);
  }

  Future<void> sendPushNotification(
      UserModel user, String msg, String sender) async {
    final body = {
      "to": user.pushToken,
      "data": {"senderId": sender, "receiver": user.id},
      "notification": {
        "title": "Message",
        "body": msg,
      }
    };
    try {
      var response = await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAA7E9dcdg:APA91bG-PkBkS7fnWV4bEfqHQ84Fwd21FA_x8tnS-RZeHvLD41RMfJOaS9lxS4oUkdBgesE822ruHhPgTz2IIKWePkWWLc753JMYhvTOyZ6mIxsgDRWO5DJ5sJBnmdevKK0ZyYWi2cjp'
          });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } on Exception catch (e) {
      print('Notification error: $e');
    }
  }
}
