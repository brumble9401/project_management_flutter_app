import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/button/button.dart';
import 'package:pma_dclv/views/widgets/inputBox.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CreateWorkspace extends StatefulWidget {
  const CreateWorkspace({super.key, required this.userUid});

  final String userUid;

  @override
  State<CreateWorkspace> createState() => _CreateWorkspaceState();
}

class _CreateWorkspaceState extends State<CreateWorkspace> {
  final TextEditingController _nameController = TextEditingController();
  String newWorkspaceUid = "";

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
      ),
      child: SizedBox(
        height: screenHeight * 0.85,
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Container(
                          height: 2.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: neutral_dark,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.sp)),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Create Workspace",
                        style: TextStyle(
                          color: neutral_dark,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
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
                      confirmBtnColor: semantic_green,
                      onConfirmBtnTap: () {
                        context
                            .read<WorkspaceCubit>()
                            .updateWorkspaceUidFromUser(
                                widget.userUid, newWorkspaceUid);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  } else if (state.workspaceStatus == WorkspaceStatus.fail) {
                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: 'Create workspace Failed!',
                    );
                  }
                }, builder: (context, state) {
                  if (state.workspaceStatus == WorkspaceStatus.initial) {
                    return Button(onPressed: createWorkspace, title: "Create");
                  } else if (state.workspaceStatus == WorkspaceStatus.loading) {
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
    );
  }
}
