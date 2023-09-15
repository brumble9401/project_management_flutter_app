import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/card/project/no_project_card.dart';
import 'package:pma_dclv/views/widgets/card/task/no_task_card.dart';
import 'package:pma_dclv/views/widgets/card/project_card.dart';

import '../../data/models/project/project_model.dart';
import '../../view-model/projects/project_cubit.dart';
import '../../view-model/tasks/task_cubit.dart';
import '../widgets/card/task/task_card.dart';

class MyOverView extends StatefulWidget {
  const MyOverView({
    super.key,
    this.workspaceUid,
  });

  final String? workspaceUid;

  @override
  State<MyOverView> createState() => _MyOverViewState();
}

class _MyOverViewState extends State<MyOverView> {
  String user_uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.projects, arguments: widget.workspaceUid.toString());
          },
          title: "Your projects",
          icon_url: "assets/icons/Project.png",
        ),
        SizedBox(
          height: 6.h,
        ),
        StreamBuilder<List<ProjectModel>>(
          stream: context.read<ProjectCubit>().getProjectFromWorkspaceUid(
              user_uid, widget.workspaceUid.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<ProjectModel> projectList = snapshot.data!;
              if (projectList.isNotEmpty) {
                return MyProjectCard(project: projectList[0]);
              } else {
                return const NoProjectCard();
              }
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        SizedBox(
          height: 10.h,
        ),
        CustomTextButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.tasks, arguments: widget.workspaceUid.toString());
          },
          title: "Your tasks",
          icon_url: "assets/icons/Task.png",
        ),
        SizedBox(
          height: 6.h,
        ),
        Container(
          decoration: const BoxDecoration(color: white),
          child: StreamBuilder<List<TaskModel>>(
            stream: context.read<TaskCubit>().getAllTaskFromWorkspace(
                user_uid, widget.workspaceUid.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<TaskModel> taskList = snapshot.data!;
                late final List<TaskModel> uncompletedTasks = taskList.where((task) => task.state == "inprogress").toList();
                if (uncompletedTasks.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: uncompletedTasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: MyTaskCard(
                          task: uncompletedTasks[index],
                          onPressed: () {
                            Navigator.pushNamed(context, RouteName.task_detail,
                                arguments: uncompletedTasks[index].id);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  // If the list is empty, display a Container with white background
                  return Container(
                    decoration: const BoxDecoration(
                      color: white,
                    ),
                    child: const Center(
                      child: NoTaskCard(),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String title;
  final String icon_url;
  final void Function()? onPressed;

  const CustomTextButton({
    super.key,
    required this.title,
    required this.icon_url,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
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
              Image.asset(
                icon_url,
                scale: 3.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: neutral_dark,
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
    );
  }
}
