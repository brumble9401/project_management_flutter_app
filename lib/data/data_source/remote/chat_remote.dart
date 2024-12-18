import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pma_dclv/data/models/chat/chat_room.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/utils/Notification_Services.dart';

abstract class ChatRemote {
  Stream<List<ChatRoom>> getChatRooms(String userId);
  Stream<ChatRoom> getRoom(String userId1, String userId2);
  Stream<ChatRoom> getRoomFromRoomUid(String roomUid);
  Future<String> createChatRoom(String userId1, String userId2);
  Stream<List<MessageModel>> getMessages(String chatRoomId);
  Future<void> sendMessage(String chatRoomId, String sender, String text, UserModel user, String type);
  Future<void> updateReadStatus(String userId, String roomId, String messageId);
}

class ChatRemoteSource extends ChatRemote {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Stream<List<ChatRoom>> getChatRooms(String userId) async* {
    final chatRoomRef = _firestore.collection('chatRooms');

    // Create a query to find the chat room where both users are participants
    final query = chatRoomRef.where('users', arrayContains: userId);

    // Start listening to the query snapshots
    final snapshots = query.snapshots();

    await for (final snapshot in snapshots) {
      // Get the chat rooms documents from the snapshots
      final chatRooms = snapshot.docs;

      // Extract the participants and messages from each chat room
      final mappedChatRooms =
          await Future.wait(chatRooms.map((chatRoomDoc) async {
        final chatRoomData = chatRoomDoc.data();
        final id = chatRoomDoc.id;
        final users = List<String>.from(chatRoomData['users']);
        final lastMess = chatRoomData['last_mess'];
        final read = chatRoomData['read'];
        final createdDate = chatRoomData['created_date'];
        final sender = chatRoomData['sender'];

        // Fetch messages for the current chat room
        final messagesSnapshot = await chatRoomDoc.reference
            .collection('messages')
            .orderBy('created_date')
            .get();
        final messages = messagesSnapshot.docs.map((messageDoc) {
          final messageData = messageDoc.data();
          return MessageModel(
            id: messageDoc.id,
            content: messageData['content'],
            senderId: messageData['user_id'],
            createdDate: messageData['created_date'].toDate(),
            readBy: List<String>.from(messageData['read_by']),
            type: messageData['type'],
          );
        }).toList();

        return ChatRoom(
          id: id,
          users: users,
          messages: messages,
          lastMess: lastMess,
          createdDate: createdDate.toDate(),
          read: read,
          sender: sender,
        );
      }));

      // Yield the list of mapped chat rooms
      yield mappedChatRooms;
    }
  }

  @override
  Stream<ChatRoom> getRoom(String userId1, String userId2) async* {
    final chatRoomRef = _firestore.collection('chatRooms');

    // Create a query to find the chat room with the specified user IDs
    final query = chatRoomRef.where('users', arrayContains: [userId1, userId2]);

    // Start listening to the query snapshots
    final snapshots = query.snapshots();

    await for (final snapshot in snapshots) {
      // Get the chat room document from the snapshots
      final chatRoomDocs = snapshot.docs;

      if (chatRoomDocs.isEmpty) {
        // No chat room found with the specified user IDs
        yield ChatRoom();
      } else {
        // Fetch messages for the chat room
        final chatRoomDoc = chatRoomDocs.first;
        final chatRoomData = chatRoomDoc.data();
        final id = chatRoomDoc.id;
        final users = List<String>.from(chatRoomData['users']);
        final read = chatRoomData['read'];
        final createdDate = chatRoomData['created_date'];
        final sender = chatRoomData['sender'];

        // Fetch messages for the chat room
        final messagesSnapshot =
            await chatRoomDoc.reference.collection('messages').get();
        final messages = messagesSnapshot.docs.map((messageDoc) {
          final messageData = messageDoc.data();
          return MessageModel(
            id: messageDoc.id,
            content: messageData['content'],
            senderId: messageData['user_id'],
            createdDate: messageData['created_date'].toDate(),
            readBy: List<String>.from(messageData['read_by']),
            type: messageData['type'],
          );
        }).toList();

        // Create the ChatRoom object
        final chatRoom = ChatRoom(
          id: id,
          users: users,
          messages: messages,
          read: read,
          createdDate: createdDate.toDate(),
          sender: sender,
        );

        // Yield the chat room
        yield chatRoom;
      }
    }
  }

  @override
  Stream<ChatRoom> getRoomFromRoomUid(String roomUid) {
    final DocumentReference<Map<String, dynamic>> docRef =
        _firestore.collection('chatRooms').doc(roomUid);

    return docRef.snapshots().asyncMap((snapshot) async {
      if (snapshot.exists) {
        final chatRoomDoc = snapshot.data();
        final id = snapshot.id;
        final users = List<String>.from(chatRoomDoc!['users']);
        final read = chatRoomDoc['read'];
        final createdDate = chatRoomDoc['created_date'];
        final sender = chatRoomDoc['sender'];

        // Fetch messages for the chat room
        final messagesSnapshot = await docRef
            .collection('messages')
            .orderBy('created_date')
            .snapshots()
            .first;

        final messages = messagesSnapshot.docs.map((messageDoc) {
          final messageData = messageDoc.data();
          return MessageModel(
            id: messageDoc.id,
            content: messageData['content'],
            senderId: messageData['user_id'],
            createdDate: messageData['created_date'].toDate(),
            readBy: List<String>.from(messageData['read_by']),
            type: messageData['type'],
          );
        }).toList();

        return ChatRoom(
          id: id,
          users: users,
          messages: messages,
          read: read,
          createdDate: createdDate.toDate(),
          sender: sender,
        );
      } else {
        return ChatRoom();
      }
    });
  }

  @override
  Future<String> createChatRoom(String userId1, String userId2) async {
    try {
      final CollectionReference<Map<String, dynamic>> chatRoomRef =
          FirebaseFirestore.instance.collection('chatRooms');
      final DocumentReference<Map<String, dynamic>> newRoomRef =
          await chatRoomRef.add({
            'users': [userId1, userId2],
            'last_mess': '',
            'read': 'false',
            'created_date': Timestamp.fromDate(DateTime.now()),
            'sender': '',
      });
      print('New project created successfully}!');
      return newRoomRef.id;
    } catch (e) {
      print('Error creating project: $e');
      return "";
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    final messagesRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');
    return messagesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['created_date'] as Timestamp;
        final createdDate = timestamp.toDate();
        return MessageModel(
          id: doc.id,
          content: data['content'],
          senderId: data['user_id'],
          createdDate: createdDate,
          readBy: List<String>.from(data['read_by']),
          type: data['type'],
        );
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(String chatRoomId, String sender, String text, UserModel user, String type) {
    final date = Timestamp.now();
    final messageRef = _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');
    final message = {
      'user_id': sender,
      'content': text,
      'created_date': date,
      'read_by': [],
      'type': type,
    };

    if(type == 'text') {
      _firestore.collection('chatRooms').doc(chatRoomId).update({
        'last_mess': text,
        'created_date': date,
        'read': 'false',
        'sender': sender,
      });
    } else if(type == 'image'){
      _firestore.collection('chatRooms').doc(chatRoomId).update({
        'last_mess': '[Image]',
        'created_date': date,
        'read': 'false',
        'sender': sender,
      });
    }

    return messageRef.add(message).then((value) => NotificationServices().sendPushNotification(user, text, sender));
  }

  @override
  Future<void> updateReadStatus(
      String userId, String roomId, String messageId) async {
    await _firestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .update({
      'read_by': [userId]
    });

    await _firestore.collection('chatRooms').doc(roomId).update({"read": "true"});
  }
}
