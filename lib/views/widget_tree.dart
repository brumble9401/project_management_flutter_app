import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/authentication/signin.dart';
import 'package:pma_dclv/views/home.dart';
import 'package:pma_dclv/views/workspace/workspace_create.dart';

class MyWidgetTree extends StatefulWidget {
  const MyWidgetTree({super.key});

  @override
  State<MyWidgetTree> createState() => _MyWidgetTreeState();
}

class _MyWidgetTreeState extends State<MyWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // The stream is still loading
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // The user is authenticated
          // return const MyHomePage();
          return StreamBuilder<UserModel>(
            stream:
                context.read<UserCubit>().getUserFromUid(snapshot.data!.uid),
            builder: (context, userSnap) {
              if (userSnap.hasData) {
                UserModel user = userSnap.data!;
                if (user.workspaceIds!.isEmpty) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (context) => WorkspaceCubit()),
                      BlocProvider(create: (context) => UserCubit()),
                    ],
                    child: WorkspaceCreate(
                      userUid: user.id.toString(),
                    ),
                  );
                } else {
                  return const MyHomePage();
                }
              } else {
                return Container();
              }
            },
          );
        } else {
          // The user is not authenticated
          return const SignInScreen();
        }
      },
    );
  }
}
