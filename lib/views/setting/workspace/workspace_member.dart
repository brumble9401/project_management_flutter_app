import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/setting/workspace/user_card.dart';
import 'package:pma_dclv/views/widgets/bottomModalSheet/add_user_to_workspace.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

enum Actions {
  delete,
  promote,
}

class MyWorkspaceMemberPage extends StatefulWidget {
  const MyWorkspaceMemberPage({
    super.key,
    required this.workspaceUid,
    required this.workspaceLeaderUid,
  });

  final String workspaceUid;
  final List<String> workspaceLeaderUid;

  @override
  State<MyWorkspaceMemberPage> createState() => _MyMemberPageState();
}

class _MyMemberPageState extends State<MyWorkspaceMemberPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              backgroundColor: white,
              centerTitle: false,
              shadowColor: Colors.transparent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      color: neutral_dark,
                      size: 19.sp,
                    ),
                  ),
                  Text(
                    "Members",
                    style: TextStyle(
                      color: neutral_dark,
                      fontSize: 20.sp,
                    ),
                  ),
                  TextButton(
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
                            BlocProvider(
                              create: (context) => UserCubit(),
                            ),
                          ],
                          child: AddUserToWorkspace(
                            workspaceUid: widget.workspaceUid,
                          ),
                        ),
                      );
                    },
                    child: const Text("Add"),
                  )
                ],
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: white,
              ),
              // child: ListView.builder(),
              child: BlocListener<WorkspaceCubit, WorkspaceState>(
                listener: (context, state) async {
                  if (state.workspaceStatus == WorkspaceStatus.success) {
                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'Success!',
                    );
                  } else if (state.workspaceStatus == WorkspaceStatus.fail) {
                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: 'Failed!',
                    );
                  }
                },
                child: StreamBuilder<List<UserModel>>(
                  stream: context
                      .read<UserCubit>()
                      .getUsersFromWorkspace(widget.workspaceUid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<UserModel> users = snapshot.data!;
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          if (users[index].id == _auth.currentUser!.uid ||
                              stringExistsInList(
                                    _auth.currentUser!.uid,
                                    widget.workspaceLeaderUid,
                                  ) ==
                                  false) {
                            return Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: UserBox(
                                isLeader: stringExistsInList(
                                  users[index].id!,
                                  widget.workspaceLeaderUid,
                                ),
                                user: users[index],
                                isSelected: false,
                                onTap: () {},
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      _onDismiss(users[index].id.toString(),
                                          Actions.promote);
                                    },
                                    backgroundColor: ascent,
                                    foregroundColor: white,
                                    icon: Icons.person_2_outlined,
                                    label: 'Promote',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      _onDismiss(users[index].id.toString(),
                                          Actions.delete);
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: UserBox(
                                isLeader: stringExistsInList(
                                  users[index].id!,
                                  widget.workspaceLeaderUid,
                                ),
                                user: users[index],
                                isSelected: false,
                                onTap: () {},
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
            ),
          ),
        ),
      ),
    );
  }

  void _onDismiss(String userUid, Actions actions) async {
    if (actions == Actions.delete) {
      await context
          .read<WorkspaceCubit>()
          .deleteUserFromWorkspace(widget.workspaceUid, userUid);
    } else if (actions == Actions.promote) {
      await context
          .read<WorkspaceCubit>()
          .updateLeaderInWorkspace(widget.workspaceUid, userUid);
    }
  }

  bool stringExistsInList(String string, List<String> list) {
    for (var item in list) {
      if (item == string) {
        return true;
      }
    }
    return false;
  }
}
