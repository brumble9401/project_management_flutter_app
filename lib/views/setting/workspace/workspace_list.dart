import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/appbar/center_title_appbar.dart';
import 'package:pma_dclv/views/widgets/bottomModalSheet/add_workspace.dart';
import 'package:pma_dclv/views/widgets/card/workspace_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Actions {
  info,
  delete,
}

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
                          child: workspaces[index]
                                  .workspaceLeaderId!
                                  .contains(_auth.currentUser!.uid)
                              ? Slidable(
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          _onDismiss(
                                            Actions.info,
                                            workspaces[index].uid!,
                                          );
                                        },
                                        backgroundColor: primary,
                                        foregroundColor: white,
                                        icon: Icons.person_2_outlined,
                                        label: 'Detail',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          _onDismiss(
                                            Actions.delete,
                                            workspaces[index].uid!,
                                          );
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: MyWorkspaceCard(
                                    workspace: workspaces[index],
                                    onPressed: () => {
                                      changeWorkspace(workspaces[index].uid),
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          RouteName.home, (route) => false),
                                    },
                                  ),
                                )
                              : Slidable(
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          _onDismiss(
                                            Actions.info,
                                            workspaces[index].uid!,
                                          );
                                        },
                                        backgroundColor: primary,
                                        foregroundColor: white,
                                        icon: Icons.person_2_outlined,
                                        label: 'Detail',
                                      ),
                                    ],
                                  ),
                                  child: MyWorkspaceCard(
                                    workspace: workspaces[index],
                                    onPressed: () => {
                                      changeWorkspace(workspaces[index].uid),
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          RouteName.home, (route) => false),
                                    },
                                  ),
                                ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => WorkspaceCubit(),
                      ),
                    ],
                    child: CreateWorkspace(
                      userUid: _auth.currentUser!.uid,
                    ),
                  ),
                );
              },
              // foregroundColor: customizations[index].$1,
              backgroundColor: primary,
              // shape: ShapeBorder(),
              child: Icon(
                FontAwesomeIcons.plus,
                size: 13.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onDismiss(Actions actions, String workspaceUid) async {
    if (actions == Actions.delete) {
      context
          .read<WorkspaceCubit>()
          .deleteWorkspace(workspaceUid)
          .then((value) => {print(value)});
    } else if (actions == Actions.info) {
      Navigator.pushNamed(
        context,
        RouteName.workspaceDetail,
        arguments: workspaceUid,
      );
    }
  }
}
