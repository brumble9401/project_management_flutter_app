import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemote {
  Future<void> firebaseLogin(String email, String password);

  Future<void> firebaseSignout();

  Future<void> firebaseRegister(
      Map<String, dynamic> obj, String email, String password);
}

class AuthRemoteSource extends AuthRemote {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> firebaseLogin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Future<void> firebaseRegister(
      Map<String, dynamic> obj, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => FirebaseFirestore.instance
              .collection('users')
              .doc(value.user!.uid)
              .set(obj));
      FirebaseFirestore.instance.collection('users').add(obj);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> firebaseSignout() async {
    await _auth.signOut();
  }
}
