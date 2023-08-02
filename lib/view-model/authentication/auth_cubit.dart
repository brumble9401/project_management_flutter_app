import 'package:bloc/bloc.dart';
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

  Future<AuthStatus> firebaseLogin(String email, String password) async {
    try {
      emit(state.copyWith(authStatus: AuthStatus.loading));
      await _authRepository.loginFirebase(email, password);
      emit(state.copyWith(authStatus: AuthStatus.authenticated));

      // final userBox = Hive.box(HiveConfig.userBox);
      // await userBox.put('isLoggedIn', true);

      LogUtil.debug('Login successfully');
      return AuthStatus.authenticated;
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.failed));
      LogUtil.error('Login error ', error: e);
      return AuthStatus.failed;
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
      await _authRepository.registerFirebase(obj, email, password);
      emit(state.copyWith(authStatus: AuthStatus.registerSuccess));
      LogUtil.debug('Register successfully');
    } catch (e, s) {
      emit(state.copyWith(authStatus: AuthStatus.registerFail));
      LogUtil.error('Register error ', error: e, stackTrace: s);
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
}
