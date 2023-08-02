import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadCubit extends Cubit<String> {
  UploadCubit() : super('');

  Future<void> uploadFileAndAddToCollection(File file, String fileName,
      String projectId, String collectionName) async {
    final storage = firebase_storage.FirebaseStorage.instance;
    final collectionRef = FirebaseFirestore.instance.collection(collectionName);
    final subcollectionRef = collectionRef.doc(projectId).collection('files');

    try {
      // Upload the file to Firebase Cloud Storage
      final ref = storage.ref().child(fileName);
      final uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded file
      final downloadURL = await ref.getDownloadURL();

      // Add the file's metadata to the subcollection
      await subcollectionRef.add({
        'file_name': fileName,
        'download_url': downloadURL,
        // Additional metadata fields as needed
      });

      print('File uploaded and added to collection successfully.');
    } catch (e) {
      print('Error uploading file and adding to collection: $e');
    }
  }

  Future<void> uploadImageAndAddToCollection(File file, String fileName,
      String projectId, String collectionName) async {
    final storage = firebase_storage.FirebaseStorage.instance;
    final collectionRef = FirebaseFirestore.instance.collection(collectionName);
    final subcollectionRef = collectionRef.doc(projectId).collection('images');

    try {
      // Upload the file to Firebase Cloud Storage
      final ref = storage.ref().child(fileName);
      final uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded file
      final downloadURL = await ref.getDownloadURL();

      // Add the file's metadata to the subcollection
      await subcollectionRef.add({
        'file_name': fileName,
        'download_url': downloadURL,
        // Additional metadata fields as needed
      });

      print('File uploaded and added to collection successfully.');
    } catch (e) {
      print('Error uploading file and adding to collection: $e');
    }
  }

  Stream<QuerySnapshot> getImageStream(String taskId, String type) {
    return FirebaseFirestore.instance
        .collection(type)
        .doc(taskId)
        .collection('images')
        .snapshots();
  }

  Stream<QuerySnapshot> getFileStream(String taskId, String type) {
    return FirebaseFirestore.instance
        .collection(type)
        .doc(taskId)
        .collection('files')
        .snapshots();
  }
}
