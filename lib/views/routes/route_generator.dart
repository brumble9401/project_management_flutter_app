import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pma_dclv/view-model/chat/chat_cubit.dart';
import 'package:pma_dclv/view-model/comment/comment_cubit.dart';
import 'package:pma_dclv/view-model/files_upload/file_cubit.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/view-model/tasks/task_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/dashboard/add_users/add_user.dart';
import 'package:pma_dclv/views/chatting/chat_room.dart';
import 'package:pma_dclv/views/dashboard/add_users/members.dart';
import 'package:pma_dclv/views/dashboard/projects/project.dart';
import 'package:pma_dclv/views/dashboard/projects/project_detail.dart';
import 'package:pma_dclv/views/dashboard/tasks/task_detail.dart';
import 'package:pma_dclv/views/dashboard/tasks/tasks.dart';
import 'package:pma_dclv/views/home.dart';
import 'package:pma_dclv/views/onBoarding.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/authentication/signin.dart';
import 'package:pma_dclv/views/authentication/signup.dart';
import 'package:pma_dclv/views/widget_tree.dart';

import '../../view-model/authentication/auth_cubit.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
    Widget? page;
    switch (settings.name) {
      case RouteName.initialRoot:
        page = BlocProvider(
          create: (context) => AuthCubit(),
          child: const MyWidgetTree(),
        );
        break;

      case RouteName.boarding:
        page = BlocProvider(
          create: (context) => AuthCubit(),
          child: const OnBoardingView(),
        );
        break;

      case RouteName.signin:
        page = BlocProvider(
          create: (context) => AuthCubit(),
          child: const SignInScreen(),
        );
        break;

      case RouteName.signup:
        page = BlocProvider(
          create: (context) => AuthCubit(),
          child: const SignupScreen(),
        );
        break;

      case RouteName.home:
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(),
            ),
            BlocProvider(
              create: (context) => WorkspaceCubit(),
            ),
          ],
          child: const MyHomePage(),
        );
        break;

      case RouteName.projects:
        page = BlocProvider(
          create: (context) => ProjectCubit(),
          child: const MyProjectView(),
        );
        break;

      case RouteName.tasks:
        page = BlocProvider(
          create: (context) => TaskCubit(),
          child: const MyTaskView(),
        );
        break;

      case RouteName.project_detail:
        final project_id = settings.arguments as String;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TaskCubit(),
            ),
            BlocProvider(
              create: (context) => ProjectCubit(),
            ),
            BlocProvider(
              create: (context) => CommentCubit(),
            ),
            BlocProvider(
              create: (context) => UserCubit(),
            ),
            BlocProvider(
              create: (context) => UploadCubit(),
            ),
          ],
          child: MyProjectDetail(
            project_id: project_id,
          ),
        );
        break;

      case RouteName.task_detail:
        final taskId = settings.arguments as String;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TaskCubit(),
            ),
            BlocProvider(
              create: (context) => CommentCubit(),
            ),
            BlocProvider(
              create: (context) => UploadCubit(),
            ),
            BlocProvider(
              create: (context) => UserCubit(),
            ),
          ],
          child: MyTaskDetail(taskId: taskId),
        );
        break;

      case RouteName.chat_room:
        final chatRoomUid = settings.arguments as String;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ChatCubit(),
            ),
            BlocProvider(
              create: (context) => UserCubit(),
            ),
          ],
          child: ChatRoomPage(
            chatRoomUid: chatRoomUid,
          ),
        );
        break;

      case RouteName.add_user:
        // final String workspaceId = settings.arguments as String;
        final List<String?> ids = settings.arguments as List<String?>;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserCubit(),
            ),
            BlocProvider(
              create: (context) => ProjectCubit(),
            ),
          ],
          child: MyAddUserPage(
            ids: ids,
          ),
        );
        break;

      case RouteName.members:
        final List<String> ids = settings.arguments as List<String>;
        page = BlocProvider(
          create: (context) => UserCubit(),
          child: MyMemberPage(
            uids: ids,
          ),
        );
    }

    return _getPageRoute(page, settings);
  }

  static PageRouteBuilder<dynamic>? _getPageRoute(
    Widget? page,
    RouteSettings settings,
  ) {
    if (page == null) {
      return null;
    }
    return PageRouteBuilder<dynamic>(
        pageBuilder: (_, __, ___) => page,
        settings: settings,
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );

          // return FadeTransition(
          //   opacity: animation,
          //   child: child,
          // );
        });
  }
}
