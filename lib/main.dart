import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/config/hive_config.dart';
import 'package:pma_dclv/utils/Notification_Services.dart';
import 'package:pma_dclv/utils/local_notification_service.dart';
import 'package:pma_dclv/view-model/authentication/auth_cubit.dart';
import 'package:pma_dclv/views/routes/route_generator.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  LocalNotificationService.display(message);
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await HiveConfig().init();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await NotificationServices().requestNotificationPermission();
  String FCMToken = await NotificationServices().getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await preferences.setInt('initScreen', 1);

  runApp(MyApp(
    initialRoot: preferences.getInt('initScreen') == 0
        ? RouteName.boarding
        : RouteName.initialRoot,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoot});

  final String initialRoot;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthCubit()),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Kprimary,
            ),
            initialRoute: initialRoot,
            onGenerateRoute: RouteGenerator.onGenerateAppRoute,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
