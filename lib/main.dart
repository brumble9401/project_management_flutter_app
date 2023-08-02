import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/config/hive_config.dart';
import 'package:pma_dclv/view-model/authentication/auth_cubit.dart';
import 'package:pma_dclv/views/routes/route_generator.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig().init();
  Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
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
