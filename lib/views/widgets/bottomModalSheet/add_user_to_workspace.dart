import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/widgets/button/button.dart';
import 'package:pma_dclv/views/widgets/inputBox.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddUserToWorkspace extends StatefulWidget {
  const AddUserToWorkspace({super.key, required this.workspaceUid});

  final String workspaceUid;

  @override
  State<AddUserToWorkspace> createState() => _AddUserToWorkspaceState();
}

class _AddUserToWorkspaceState extends State<AddUserToWorkspace> {
  final TextEditingController _nameController = TextEditingController();

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
                        "Add User",
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
                      "User email",
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
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  } else if (state.workspaceStatus == WorkspaceStatus.fail) {
                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: state.errorMessage,
                    );
                  }
                }, builder: (context, state) {
                  if (state.workspaceStatus == WorkspaceStatus.initial) {
                    return Button(
                      onPressed: () async {
                        await context.read<WorkspaceCubit>().addUserToWorkspace(
                              widget.workspaceUid,
                              _nameController.text,
                            );
                      },
                      title: "Create",
                    );
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
