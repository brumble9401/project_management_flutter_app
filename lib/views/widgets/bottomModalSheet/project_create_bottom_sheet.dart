import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pma_dclv/data/models/network/base_response.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/button/button.dart';
import 'package:pma_dclv/views/widgets/button/iconButton.dart';
import 'package:pma_dclv/views/widgets/inputBox.dart';

class MyProjectBottomModalSheet extends StatefulWidget {
  const MyProjectBottomModalSheet({
    super.key,
    required this.title,
    required this.workspaceUid,
  });

  final String title;
  final String workspaceUid;

  @override
  State<MyProjectBottomModalSheet> createState() =>
      _MyProjectBottomModalSheetState();
}

class _MyProjectBottomModalSheetState extends State<MyProjectBottomModalSheet> {
  final TextEditingController _nameController = TextEditingController();
  final quill.QuillController _descriptionController =
      quill.QuillController.basic();

  DateTime deadline = DateTime.now();
  List<UserModel> users = [];
  List<int> usersId = [];
  String user_uid = FirebaseAuth.instance.currentUser!.uid.toString();
  BaseResponse<ProjectModel> project = BaseResponse<ProjectModel>();
  String projectUid = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void createProject() async {
    Map<String, dynamic> project = ({
      "project_name": _nameController.text,
      "description":
          jsonEncode(_descriptionController.document.toDelta().toJson()),
      "deadline": Timestamp.fromDate(deadline),
      "users_id": [user_uid],
      "created_date": Timestamp.fromDate(DateTime.now()),
      "workspace_id": widget.workspaceUid,
      "state": "inprogress",
      "finished_time": Timestamp.fromDate(DateTime.now()),
    });

    projectUid = await context.read<ProjectCubit>().createProject(project);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<WorkspaceModel>(
      stream: context
          .read<WorkspaceCubit>()
          .getWorkspaceFromUid(widget.workspaceUid),
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
          ),
          child: SizedBox(
            height: screenHeight * 0.85,
            child: Padding(
              padding: EdgeInsets.all(20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Center(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              color: neutral_dark,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Workspace: ",
                              style: TextStyle(
                                color: neutral_grey,
                                fontSize: 13.sp,
                              ),
                            ),
                            snapshot.hasData
                                ? Text(
                                    snapshot.data!.workspaceName!,
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                      ),
                      Text(
                        "Name",
                        style: TextStyle(
                          color: neutral_dark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      InputBox(
                        controller: _nameController,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Member",
                        style: TextStyle(
                          color: neutral_dark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      BlocConsumer<UserCubit, UserState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if (state.userStatus == UserStatus.loading) {
                            return const CircularProgressIndicator();
                          }
                          return SizedBox(
                            height: 40.w,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: usersId.length + 1,
                              itemBuilder: (context, index) {
                                if (index == usersId.length) {
                                  return Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: white,
                                      border: Border.all(
                                        color: neutral_lightgrey,
                                        style: BorderStyle.solid,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(40.w),
                                        ),
                                      ))),
                                      child: Icon(
                                        FontAwesomeIcons.plus,
                                        color: neutral_grey,
                                        size: 10.sp,
                                      ),
                                    ), // Add your content here
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: Container(
                                    width: 40.w,
                                    // height: ,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: const CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage('assets/images/dog.png'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Deadline",
                        style: TextStyle(
                          color: neutral_dark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDueDate(DateFormat.yMMMd().format(deadline),
                              primary, DateFormat.jm().format(deadline)),
                          IconBtn(
                            onPressed: () {
                              showDateTimePicker();
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              color: white,
                              size: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(
                          color: neutral_dark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      _descriptionController.getPlainText().isEmpty
                          ? IconBtn(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RouteName.textEditing, arguments: {
                                  'controller': _descriptionController,
                                  'projectUid': '',
                                  'type': ''
                                });
                              },
                              icon: Icon(
                                FontAwesomeIcons.add,
                                color: white,
                                size: 14.sp,
                              ),
                            )
                          : Text(
                              _descriptionController.getPlainText(),
                              style: const TextStyle(
                                color: neutral_dark,
                              ),
                            ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: BlocConsumer<ProjectCubit, ProjectState>(
                      listener: (context, state) {
                        if (state.projectStatus == ProjectStatus.success) {
                          Navigator.pushReplacementNamed(
                            context,
                            RouteName.project_detail,
                            arguments: {
                              'projectUid': projectUid,
                              'workspaceUid': widget.workspaceUid,
                            },
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.projectStatus == ProjectStatus.loading) {
                          return Button(
                            onPressed: () {},
                            title: "Creating ...",
                          );
                        }
                        return Button(
                          onPressed: () {
                            createProject();
                          },
                          title: "Create",
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDateTimePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: deadline,
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(deadline),
      );

      if (selectedTime != null) {
        setState(() {
          deadline = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Widget _buildDueDate(String date, Color color, String time) {
    return Container(
      width: 250.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: neutral_lightgrey),
        boxShadow: const [
          BoxShadow(
            color: neutral_lightgrey,
            spreadRadius: 2,
            blurRadius: 9,
            offset: Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
          ),
          Text(
            "Date:    $date",
            style: TextStyle(
              color: neutral_dark,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Text(
            time,
            style: TextStyle(
              color: neutral_grey,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
