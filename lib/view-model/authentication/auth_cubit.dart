import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pma_dclv/data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/log_util.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());
  final _authRepository = AuthRepository.instance();
  final _auth = FirebaseAuth.instance;

  // Future<void> firebaseLogin(String email, String password) async {
  //   try {
  //     emit(state.copyWith(authStatus: AuthStatus.loading));
  //     // await _authRepository.loginFirebase(email, password);
  //     _auth.signInWithEmailAndPassword(email: email, password: password);
  //     emit(state.copyWith(authStatus: AuthStatus.authenticated));
  //     LogUtil.debug('Login successfully');
  //   } on FirebaseAuthException catch (e) {
  //     emit(state.copyWith(authStatus: AuthStatus.failed));
  //     emit(state.copyWith(errorMessage: e.toString()));
  //     LogUtil.error('Login error ', error: e);
  //   }
  // }

  Future<void> firebaseLogin(String email, String password) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      emit(state.copyWith(authStatus: AuthStatus.authenticated));
      LogUtil.debug('Login successfully');
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.failed));
      emit(state.copyWith(errorMessage: e.message));
      LogUtil.error('Login error', error: e);
    }
  }

  void logout() async {
    _authRepository.signOutFirebase();
    // final userBox = Hive.box(HiveConfig.userBox);
    // await userBox.put('isLoggedIn', false);
    emit(state.copyWith(authStatus: AuthStatus.initial));
  }

  void checkAuthStatus() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(authStatus: AuthStatus.initial));
      }
    });
  }

  Future<void> firebaseRegister(
      Map<String, dynamic> obj, String email, String password) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
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
      emit(state.copyWith(authStatus: AuthStatus.registerSuccess));
      LogUtil.debug('Register successfully');
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.registerFail));
      emit(state.copyWith(errorMessage: e.message));
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      LogUtil.error('Register error ', error: e);
    }
  }

  Future<void> firebaseSignOut() async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('selectedWorkspaceUid');
    await _authRepository.signOutFirebase();
    LogUtil.info("Logout successfully");
    emit(state.copyWith(authStatus: AuthStatus.success));
  }

  Future<void> changePassword(
      String email, String password, String newPassword) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      final user = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user?.reauthenticateWithCredential(credential);

      // Password is verified; change to the new password.
      await user?.updatePassword(newPassword);

      emit(state.copyWith(authStatus: AuthStatus.success));
    } catch (e) {
      // Handle errors, such as incorrect old password.
    }
  }
}
