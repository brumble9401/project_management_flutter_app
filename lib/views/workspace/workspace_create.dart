import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/button/button.dart';
import 'package:pma_dclv/views/widgets/inputBox.dart';
import 'package:quickalert/quickalert.dart';

class WorkspaceCreate extends StatefulWidget {
  const WorkspaceCreate({super.key, required this.userUid});

  final String userUid;

  @override
  State<WorkspaceCreate> createState() => _WorkspaceCreateState();
}

class _WorkspaceCreateState extends State<WorkspaceCreate> {
  final TextEditingController _nameController = TextEditingController();
  String newWorkspaceUid = "";

  void createWorkspace() async {
    Map<String, dynamic> obj = {
      "workspace_name": _nameController.text.toString(),
      "leaders_id": [
        widget.userUid,
      ],
      "users_id": [
        widget.userUid,
      ],
      "created_date": Timestamp.fromDate(DateTime.now()),
    };

    newWorkspaceUid = await context
        .read<WorkspaceCubit>()
        .createWorkspace(obj, widget.userUid);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              color: white,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
                          child: Center(
                            child: SizedBox(
                              width: 130.w,
                              child: const Image(
                                image: AssetImage(
                                    'assets/images/illustration.png'),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Create New Workspace",
                            style: TextStyle(
                              color: neutral_dark,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Text(
                          "Workspace name",
                          style: TextStyle(
                            color: neutral_dark,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        InputBox(
                          controller: _nameController,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: BlocConsumer<WorkspaceCubit, WorkspaceState>(
                        listener: (context, state) async {
                      if (state.workspaceStatus == WorkspaceStatus.success) {
                        await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Create workspace Completed Successfully!',
                            confirmBtnText: 'Yes',
                            confirmBtnColor: primary,
                            onConfirmBtnTap: () {
                              context
                                  .read<WorkspaceCubit>()
                                  .updateWorkspaceUidFromUser(
                                      widget.userUid, newWorkspaceUid);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteName.initialRoot,
                                (route) => false,
                              );
                            });
                      } else if (state.workspaceStatus ==
                          WorkspaceStatus.fail) {
                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: 'Create workspace Failed!',
                        );
                      }
                    }, builder: (context, state) {
                      if (state.workspaceStatus == WorkspaceStatus.initial) {
                        return Button(
                            onPressed: createWorkspace, title: "Create");
                      } else if (state.workspaceStatus ==
                          WorkspaceStatus.loading) {
                        return Button(onPressed: () {}, title: "Creating...");
                      } else {
                        return Button(onPressed: () {}, title: "Creating...");
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
