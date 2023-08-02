import '../data_source/remote/auth_remote.dart';

class AuthRepository {
  late final AuthRemoteSource _authRemoteSource;
  // late final AuthLocalSource _authLocalSource;

  AuthRepository._internal() {
    _authRemoteSource = AuthRemoteSource();
    // _authLocalSource = AuthLocalSource();
  }

  static final _instance = AuthRepository._internal();

  factory AuthRepository.instance() => _instance;

  Future<void> loginFirebase(String email, String password) async {
    await _authRemoteSource.firebaseLogin(email, password);
  }

  Future<void> registerFirebase(
      Map<String, dynamic> obj, String email, String password) async {
    await _authRemoteSource.firebaseRegister(obj, email, password);
  }

  Future<void> signOutFirebase() async {
    await _authRemoteSource.firebaseSignout();
  }
}
