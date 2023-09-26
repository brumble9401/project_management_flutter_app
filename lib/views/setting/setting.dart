import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';
import 'package:pma_dclv/main.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/button/button.dart';
import 'package:pma_dclv/views/widgets/button/text_icon_button.dart';
import 'package:pma_dclv/views/widgets/card/workspace_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view-model/authentication/auth_cubit.dart';
import 'user_card.dart';

class MySettingPage extends StatefulWidget {
  const MySettingPage({super.key});

  @override
  State<MySettingPage> createState() => _MySettingPageState();
}

class _MySettingPageState extends State<MySettingPage> {
  final _auth = FirebaseAuth.instance;
  String workspaceUid = "";
  bool isLoading = false;

  void getWorkspaceUid() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedWorkspaceUid = prefs.getString('selectedWorkspaceUid');
    if (selectedWorkspaceUid != null && selectedWorkspaceUid.isNotEmpty) {
      setState(() {
        workspaceUid = selectedWorkspaceUid;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getWorkspaceUid();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
      decoration: const BoxDecoration(
        color: white,
      ),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: white,
          centerTitle: false,
          shadowColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Setting",
                style: TextStyle(
                  color: neutral_dark,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(color: white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Container(
                      width: double.infinity,
                      height: 70.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                      ),
                      child: BlocProvider(
                        create: (context) => UserCubit(),
                        child: MyUserCard(
                          userUid: _auth.currentUser!.uid.toString(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Workspace",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextIconButton(
                          icon: Icons.change_circle_outlined,
                          text: "Change",
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteName.workspaceList);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100.h,
                    decoration: const BoxDecoration(
                      color: white,
                    ),
                    child: isLoading == false
                        ? StreamBuilder<WorkspaceModel>(
                            stream: workspaceUid.isNotEmpty
                                ? context
                                    .read<WorkspaceCubit>()
                                    .getWorkspaceFromUid(workspaceUid)
                                : null,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final WorkspaceModel workspace = snapshot.data!;
                                return MyWorkspaceCard(workspace: workspace);
                              } else {
                                return Container();
                              }
                            },
                          )
                        : Container(
                            width: double.infinity,
                            height: 90.h,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: neutral_lightgrey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: neutral_lightgrey,
                                  spreadRadius: 2,
                                  blurRadius: 9,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                  ),
                ],
              ),
              Column(
                children: [
                  Button(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteName.changePassword);
                    },
                    title: 'Change Password',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state.authStatus == AuthStatus.success) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyApp(
                                      initialRoot: '',
                                    )));
                      }
                    },
                    builder: (context, state) {
                      if (state.authStatus == AuthStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      return Button(
                        onPressed: () async {
                          await context.read<AuthCubit>().firebaseSignOut();
                        },
                        title: "Sign out",
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
