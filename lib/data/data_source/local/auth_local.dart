// import 'package:hive/hive.dart';
// import 'package:pma_dclv/data/config/hive_config.dart';
// import 'package:pma_dclv/data/models/authentication/user.dart';
// import 'package:pma_dclv/utils/log_util.dart';

// import '../../models/network/exception.dart';

// abstract class AuthLocal {
//   void saveCurrentUser(User user);

//   User getCurrentUser();

//   Box getUserBox();

//   void clearCurrentUser();

//   bool isNotEmpty();
// }

// class AuthLocalSource extends AuthLocal {
//   @override
//   void saveCurrentUser(User user) async {
//     try {
//       final userBox = Hive.box(HiveConfig.userBox);

//       // await userBox.put(HiveConfig.userKey, user);
//       LogUtil.debug("Saved user: $user");
//     } catch (e, s) {
//       LogUtil.error('Save user error: $e', error: e, stackTrace: s);
//       throw LocalException(
//           LocalException.unableSaveUser, 'Unable Save User: $e');
//     }
//   }

//   // @override
//   // User getCurrentUser() {
//   //   // TODO: implement getCurrentUser
//   //   final userBox = Hive.box(HiveConfig.userBox);
//   //   return userBox.get(HiveConfig.userKey);
//   // }

//   @override
//   Box getUserBox() {
//     // TODO: implement getUserBox
//     throw UnimplementedError();
//   }

//   @override
//   void clearCurrentUser() async {
//     // TODO: implement clearCurrentUser
//     try {
//       final userBox = Hive.box(HiveConfig.userBox);
//       await userBox.clear();
//     } catch (e) {}
//   }

//   @override
//   bool isNotEmpty() {
//     // TODO: implement isNotEmpty
//     final userBox = Hive.box(HiveConfig.userBox);
//     return userBox.isNotEmpty ? true : false;
//   }
// }
