import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/chat/chat_cubit.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/view-model/tasks/task_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/chatting/chatting.dart';
import 'package:pma_dclv/views/dashboard/dashboard.dart';
import 'package:pma_dclv/views/notification/notification.dart';
import 'package:pma_dclv/views/setting/setting.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _page = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProjectCubit(),
        ),
        BlocProvider(
          create: (context) => TaskCubit(),
        ),
        BlocProvider(
          create: (context) => WorkspaceCubit(),
        ),
      ],
      child: const MyDashBoard(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => WorkspaceCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
      ],
      child: MyChatPage(),
    ),
    const MyNotificationPage(),
    BlocProvider(
      create: (context) => WorkspaceCubit(),
      child: const MySettingPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 80.h,
        child: CustomNavigationBar(
          isFloating: true,
          borderRadius: Radius.circular(20.w),
          strokeColor: primary,
          currentIndex: _currentIndex,
          selectedColor: primary,
          unSelectedColor: neutral_grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            CustomNavigationBarItem(
              icon: const Icon(Icons.home),
              // title: Text("Dasho"),
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble),
              // title: 'Search',
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.notifications_outlined),
              // title: 'Search',
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.settings),
              // title: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}
