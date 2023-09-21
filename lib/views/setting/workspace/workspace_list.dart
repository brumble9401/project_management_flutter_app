import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/appbar/center_title_appbar.dart';
import 'package:pma_dclv/views/widgets/card/workspace_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkspaceListPage extends StatefulWidget {
  const WorkspaceListPage({super.key});

  @override
  State<WorkspaceListPage> createState() => _WorkspaceListPageState();
}

class _WorkspaceListPageState extends State<WorkspaceListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void changeWorkspace(workspaceUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedWorkspaceUid", workspaceUid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
          child: Scaffold(
            appBar: MyCenterTitleAppBar(
              title: "Workspace List",
              onPressed: () => Navigator.pop(context),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: white,
              ),
              child: StreamBuilder<List<WorkspaceModel>>(
                  stream: context
                      .read<WorkspaceCubit>()
                      .getWorkspaceFromUser(_auth.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<WorkspaceModel> workspaces = snapshot.data!;
                      return ListView.builder(
                        itemCount: workspaces.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: MyWorkspaceCard(
                              workspace: workspaces[index],
                              onPressed: () => {
                                // changeWorkspace(workspaces[index].uid),
                                // Navigator.pushNamedAndRemoveUntil(
                                //     context, RouteName.home, (route) => false),
                                Navigator.pushNamed(
                                    context, RouteName.workspaceDetail,
                                    arguments: workspaces[index].uid)
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
