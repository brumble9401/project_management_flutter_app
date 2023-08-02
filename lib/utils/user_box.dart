import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pma_dclv/utils/user_adapter.dart';

class UserBox {
  static const String _userBoxName = 'userBox';

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(UserAdapter());
  }

  Future<Box<User>> openBox() async {
    if (!Hive.isBoxOpen(_userBoxName)) {
      return await Hive.openBox<User>(_userBoxName);
    }
    return Hive.box<User>(_userBoxName);
  }
}
