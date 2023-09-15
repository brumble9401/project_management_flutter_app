import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/bottomModalSheet/bottom_modal_sheet.dart';
import 'package:pma_dclv/views/widgets/card/comment_card.dart';
import 'package:pma_dclv/views/widgets/comment_box.dart';

import 'package:pma_dclv/data/models/comment/comment_model.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';
import 'package:pma_dclv/view-model/comment/comment_cubit.dart';
import 'package:pma_dclv/view-model/files_upload/file_cubit.dart';
import 'package:pma_dclv/view-model/tasks/task_cubit.dart';
import 'package:pma_dclv/views/widgets/appbar/non_title_appbar.dart';
import 'package:pma_dclv/views/widgets/card/file_card.dart';
import 'package:pma_dclv/views/widgets/card/images_add_card.dart';
import 'package:pma_dclv/views/widgets/card/task/task_add_card.dart';
import 'package:pma_dclv/views/widgets/card/task/task_card_2.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

enum _MenuValues {
  addUser,
  markDone,
  deleteProject,
}

class MyProjectDetail extends StatefulWidget {
  const MyProjectDetail({super.key, required this.project_id});

  final String project_id;

  @override
  State<MyProjectDetail> createState() => _MyProjectDetailState();
}

class _MyProjectDetailState extends State<MyProjectDetail> {
  final TextEditingController _commentController = TextEditingController();
  late quill.QuillController _quillController;

  ProjectModel project = ProjectModel();
  String user_uid = FirebaseAuth.instance.currentUser!.uid;
  List<String> userUids = [];
  PlatformFile? pickedImage;
  PlatformFile? pickedFile;

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  void addImage(File file, String fileName) async {
    await context.read<UploadCubit>().uploadImageAndAddToCollection(
        file, fileName, widget.project_id, 'projects');
  }

  void addFile(File file, String fileName) async {
    await context.read<UploadCubit>().uploadFileAndAddToCollection(
        file, fileName, widget.project_id, 'projects');
  }

  void sendComment(String projectUid, String userUid, String content) async {
    await context
        .read<CommentCubit>()
        .createProjectComment(projectUid, userUid, content);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProjectModel>(
      stream: context.read<ProjectCubit>().getProjectFromUid(widget.project_id),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          project = snapshot.data!;
          userUids = project.userIds!;

          List<dynamic> initialContentMap = jsonDecode(project.description.toString());
          _quillController = quill.QuillController(
            document: quill.Document.fromJson(initialContentMap),
            selection: const TextSelection.collapsed(offset: 0),
          );

          return Container(
            decoration: const BoxDecoration(
              color: white,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
                child: SafeArea(
                  child: Scaffold(
                    appBar: MyNonTitleAppbar(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      hasIconButton: true,
                      btn: Container(
                        width: 40.w, // Set the desired width
                        height: 40.w,
                        decoration: const BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        child: PopupMenuButton<_MenuValues>(
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: _MenuValues.addUser,
                              child: Text('Add users'),
                            ),
                            const PopupMenuItem(
                              value: _MenuValues.markDone,
                              child: Text('Mark done'),
                            ),
                            const PopupMenuItem(
                              value: _MenuValues.deleteProject,
                              child: Text('Delete project'),
                            ),
                          ],
                          icon: Icon(FontAwesomeIcons.plus, color: white, size: 15.sp,),
                          onSelected: (value) {
                            switch (value) {
                              case _MenuValues.addUser:
                                Navigator.pushNamed(context, RouteName.add_user,
                                    arguments: {'uids':[project.workspaceId, project.id], 'type': 'projects'});
                                break;

                              case _MenuValues.markDone:
                                context.read<ProjectCubit>().updateProjectStatus(widget.project_id, 'finished');
                                break;

                              case _MenuValues.deleteProject:
                                context.read<ProjectCubit>().deleteProject(widget.project_id).then((_) {
                                  Navigator.pop(context);
                                }).catchError((error) {
                                  // Handle any errors here, if needed
                                  print("Error deleting project: $error");
                                });
                                break;
                            }
                          },
                        ),
                      ),

                    ),
                    body: Container(
                      decoration: const BoxDecoration(
                        color: white,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: Center(
                                        child: Text(
                                          project.name.toString(),
                                          style: TextStyle(
                                            color: neutral_dark,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.check,
                                                color: neutral_dark,
                                                size: 17.sp,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                "Status",
                                                style: TextStyle(
                                                  color: neutral_dark,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            project.state.toString() ==
                                                    "finished"
                                                ? "Done"
                                                : "In progress",
                                            style: TextStyle(
                                              color: project.state == "finished"
                                                  ? semantic_green
                                                  : ascent,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _buildDeadline(project.deadline),
                                    _buildMember(userUids),
                                    _buildDescription(_quillController.document.toPlainText().toString()),
                                    _buildImages(),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    _buidFiles(),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    _buildTasks(project.workspaceId.toString()),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    _buildComment(project.id.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          MyCommentBox(
                            controller: _commentController,
                            onPressed: () {
                              if (_commentController.text != "") {
                                sendComment(project.id.toString(), user_uid,
                                    _commentController.text);
                                _commentController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildDeadline(DateTime? deadline) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.clock,
                color: neutral_dark,
                size: 17.sp,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                "Due date",
                style: TextStyle(
                  color: neutral_dark,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDueDate(
                  DateFormat.yMMMd()
                      .format(DateTime.parse(project.createdDate.toString())),
                  neutral_dark,
                  DateFormat.jm()
                      .format(DateTime.parse(project.createdDate.toString()))),
              _buildDueDate(
                  DateFormat.yMMMd()
                      .format(DateTime.parse(project.deadline.toString())),
                  primary,
                  DateFormat.jm()
                      .format(DateTime.parse(project.deadline.toString()))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.description_outlined),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                      color: neutral_dark,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.textEditing, arguments: {
                    'controller': _quillController,
                    'projectUid': widget.project_id,
                    'type': 'projects',
                  });
                },
                child: const Icon(
                  Icons.edit_outlined,
                  color: neutral_dark,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 20.h),
          decoration: const BoxDecoration(
            color: white,
          ),
          child: Text(
            description,
            style: TextStyle(
              color: neutral_grey,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMember(List<String> userUids) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5.h,
      ),
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteName.members,
            arguments: {'uids':userUids, 'projectUid': project.id, 'workspaceUid': project.workspaceId, 'type': 'projects'},
          );
        },
        style: ButtonStyle(
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.transparent),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.only(left: 0.0, right: 0.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 20.sp,
                  color: neutral_dark,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "Members",
                  style: TextStyle(
                    color: neutral_dark,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: neutral_dark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDate(String date, Color color, String time) {
    return Container(
      width: 150.w,
      height: 70.h,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 40.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.clock,
                color: white,
                size: 19.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: neutral_dark,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildImages() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.task_outlined),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Images",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: neutral_dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await pickImage();
                  if (pickedImage != null) {
                    addImage(File(pickedImage!.path!), pickedImage!.name);
                  } else {
                    // File picking canceled
                  }
                },
                child: const Icon(
                  FontAwesomeIcons.plus,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 70.h,
          decoration: const BoxDecoration(
            color: white,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: context
                .read<UploadCubit>()
                .getImageStream(widget.project_id, 'projects'),
            builder: (context, snap) {
              if (snap.hasData) {
                final querySnapshot = snap.data as QuerySnapshot;
                final images = querySnapshot.docs.map((doc) {
                  return doc['download_url']
                      as String; // Replace 'image_url' with the correct field name in your Firestore document
                }).toList();
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == images.length) {
                      return MyImageAddCard(
                        onPressed: () async {
                          await pickImage();
                          if (pickedImage != null) {
                            addImage(
                                File(pickedImage!.path!), pickedImage!.name);
                          } else {
                            // File picking canceled
                          }
                        },
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.w),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: 150.w,
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/image_scence.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 150.w,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buidFiles() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.task_outlined),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Files",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: neutral_dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await pickFile();
                  if (pickedFile != null) {
                    addFile(File(pickedFile!.path!), pickedFile!.name);
                  } else {
                    // File picking canceled
                  }
                },
                child: const Icon(
                  FontAwesomeIcons.plus,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 50.h,
          decoration: const BoxDecoration(
            color: white,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: context
                .read<UploadCubit>()
                .getFileStream(widget.project_id, 'projects'),
            builder: (context, snap) {
              if (snap.hasData) {
                final querySnapshot = snap.data as QuerySnapshot;
                final filesUrl = querySnapshot.docs.map((doc) {
                  return doc['download_url']
                      as String; // Replace 'image_url' with the correct field name in your Firestore document
                }).toList();
                final filesName = querySnapshot.docs.map((doc) {
                  return doc['file_name']
                      as String; // Replace 'image_url' with the correct field name in your Firestore document
                }).toList();
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filesUrl.length + 1,
                  itemBuilder: (context, index) {
                    if (index == filesUrl.length) {
                      return MyImageAddCard(
                        onPressed: () async {
                          await pickFile();
                          if (pickedFile != null) {
                            addFile(File(pickedFile!.path!), pickedFile!.name);
                          } else {
                            // File picking canceled
                          }
                        },
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: MyFileCard(
                        fileUrl: filesUrl[index],
                        fileName: filesName[index],
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/image_scence.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 150.w,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTasks(String workspaceUid) {
    return StreamBuilder<List<TaskModel>>(
        stream:
            context.read<TaskCubit>().getTaskFromProjectUid(widget.project_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TaskModel> tasks = snapshot.data!;
            // print(tasks);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.task_outlined),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Tasks",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: neutral_dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
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
                                create: (context) => TaskCubit(),
                              ),
                              BlocProvider(
                                create: (context) => UserCubit(),
                              ),
                            ],
                            child: MyBottomModalSheet(
                              title: "Create Task",
                              projectId: widget.project_id.toString(),
                              workspaceId: workspaceUid,
                            ),
                          ),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.plus,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 180.h,
                  decoration: const BoxDecoration(
                    color: white,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tasks.length + 1,
                    itemBuilder: (context, index) {
                      if (index == tasks.length) {
                        return MyTaskAddCard(projectUid: widget.project_id, workspaceUid: workspaceUid,);
                      }
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: MyTaskCard2(
                          task: tasks[index],
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.task_detail,
                              arguments: tasks[index].id.toString(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildComment(String projectUid) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              const Icon(Icons.comment_outlined),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "Comments",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: neutral_dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<List<CommentModel>>(
          stream: context.read<CommentCubit>().getProjectComment(projectUid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CommentModel> comments = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return MyCommentCard(
                    comment: comments[index],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _quillController.dispose();
    super.dispose();
  }
}
