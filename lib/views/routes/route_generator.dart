import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pma_dclv/view-model/authentication/auth_cubit.dart';
import 'package:pma_dclv/view-model/chat/chat_cubit.dart';
import 'package:pma_dclv/view-model/comment/comment_cubit.dart';
import 'package:pma_dclv/view-model/files_upload/file_cubit.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/view-model/tasks/task_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/authentication/signin.dart';
import 'package:pma_dclv/views/authentication/signup.dart';
import 'package:pma_dclv/views/chatting/chat_room.dart';
import 'package:pma_dclv/views/dashboard/add_users/add_user.dart';
import 'package:pma_dclv/views/dashboard/add_users/members.dart';
import 'package:pma_dclv/views/dashboard/projects/project.dart';
import 'package:pma_dclv/views/dashboard/projects/project_detail.dart';
import 'package:pma_dclv/views/dashboard/tasks/task_detail.dart';
import 'package:pma_dclv/views/dashboard/tasks/tasks.dart';
import 'package:pma_dclv/views/home.dart';
import 'package:pma_dclv/views/onBoarding.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/setting/change_password.dart';
import 'package:pma_dclv/views/setting/profile.dart';
import 'package:pma_dclv/views/setting/workspace/workspace_detail.dart';
import 'package:pma_dclv/views/setting/workspace/workspace_list.dart';
import 'package:pma_dclv/views/setting/workspace/workspace_member.dart';
import 'package:pma_dclv/views/widget_tree.dart';
import 'package:pma_dclv/views/widgets/text_editing/text_editing_page.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateAppRoute(RouteSettings settings) {
    Widget? page;
    switch (settings.name) {
      case RouteName.initialRoot:
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(),
            ),
            BlocProvider(
              create: (context) => UserCubit(),
            ),
          ],
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
        final String workspaceUid = settings.arguments as String;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProjectCubit(),
            ),
            BlocProvider(
              create: (context) => WorkspaceCubit(),
            ),
            BlocProvider(
              create: (context) => TaskCubit(),
            ),
          ],
          child: MyProjectView(
            workspaceUid: workspaceUid,
          ),
        );
        break;

      case RouteName.tasks:
        final String workspaceUid = settings.arguments as String;
        page = BlocProvider(
          create: (context) => TaskCubit(),
          child: MyTaskView(
            workspaceUid: workspaceUid,
          ),
        );
        break;

      case RouteName.project_detail:
        final arguments = settings.arguments as Map<String, dynamic>;
        final project_id = arguments['projectUid'] as String;
        final workspaceUid = arguments['workspaceUid'] as String;

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
            BlocProvider(
              create: (context) => WorkspaceCubit(),
            ),
          ],
          child: MyProjectDetail(
            project_id: project_id,
            workspaceUid: workspaceUid,
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
            BlocProvider(
              create: (context) => WorkspaceCubit(),
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
        final arguments = settings.arguments as Map<String, dynamic>;
        final List<String?> ids = arguments['uids'] as List<String?>;
        final String type = arguments['type'] as String;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserCubit(),
            ),
            BlocProvider(
              create: (context) => ProjectCubit(),
            ),
            BlocProvider(
              create: (context) => TaskCubit(),
            ),
          ],
          child: MyAddUserPage(
            ids: ids,
            type: type,
          ),
        );
        break;

      case RouteName.members:
        final arguments = settings.arguments as Map<String, dynamic>;
        final List<String> ids = arguments['uids'] as List<String>;
        final String projectUid = arguments['projectUid'] as String;
        final String workspaceUid = arguments['workspaceUid'] as String;
        final String type = arguments['type'] as String;
        page = BlocProvider(
          create: (context) => UserCubit(),
          child: MyMemberPage(
            uids: ids,
            projectUid: projectUid,
            workspaceUid: workspaceUid,
            type: type,
          ),
        );
        break;

      case RouteName.profile:
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserCubit(),
            ),
            BlocProvider(
              create: (context) => UploadCubit(),
            ),
          ],
          child: const ProfilePage(),
        );
        break;

      case RouteName.textEditing:
        final arguments = settings.arguments as Map<String, dynamic>;
        final quill.QuillController controller =
            arguments['controller'] as quill.QuillController;
        final projectUid = arguments['projectUid'] as String;
        final String type = arguments['type'] as String;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProjectCubit(),
            ),
            BlocProvider(
              create: (context) => TaskCubit(),
            ),
          ],
          child: TextEditingPage(
            controller: controller,
            projectUid: projectUid,
            type: type,
          ),
        );
        break;

      case RouteName.workspaceList:
        page = MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => WorkspaceCubit()),
            BlocProvider(create: (context) => UserCubit()),
          ],
          child: const WorkspaceListPage(),
        );
        break;

      case RouteName.workspaceDetail:
        final String workspaceUid = settings.arguments as String;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => WorkspaceCubit()),
            BlocProvider(create: (context) => UserCubit()),
          ],
          child: WorkspaceDetail(workspaceUid: workspaceUid),
        );
        break;

      case RouteName.workspaceMember:
        final arguments = settings.arguments as Map<String, dynamic>;
        final String workspaceUid = arguments['workspaceUid'] as String;
        final List<String> workspaceLeaderUid =
            arguments['workspaceLeaderUid'] as List<String>;
        page = MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => WorkspaceCubit()),
            BlocProvider(create: (context) => UserCubit()),
          ],
          child: MyWorkspaceMemberPage(
            workspaceUid: workspaceUid,
            workspaceLeaderUid: workspaceLeaderUid,
          ),
        );
        break;

      case RouteName.changePassword:
        page = BlocProvider(
          create: (context) => AuthCubit(),
          child: ChangePasswordPage(),
        );
        break;
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
