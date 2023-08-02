import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive/hive.dart';

class HiveConfig {
  static const userBox = 'AUTH_USER';
  static const isLoggedInKey = 'isLoggedIn';

  Future<void> init() async {
    await Hive.deleteFromDisk();
    await Hive.initFlutter();
    // Hive.registerAdapter<bool>(TypeAdapter<bool>());

    await Hive.openBox<bool>(userBox);
  }
}
