import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/views/widgets/card/project/no_project_card.dart';

import '../../routes/route_name.dart';
import '../../widgets/card/project_card.dart';

class MyCompletedProjects extends StatefulWidget {
  const MyCompletedProjects({
    super.key,
    required this.name,
    required this.workspaceUid,
  });

  final String name;
  final String workspaceUid;

  @override
  State<MyCompletedProjects> createState() => _MyCompletedProjectsState();
}

class _MyCompletedProjectsState extends State<MyCompletedProjects> {
  ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // late final List<ProjectModel> finishedProject = widget.projects
  //     .where((project) => project.state.toString() == "finished")
  //     .toList();

  @override
  Widget build(BuildContext context) {
    // if (finishedProject.isEmpty) {
    //   return const NoProjectCard();
    // }
    return StreamBuilder<List<ProjectModel>>(
      stream: context.read<ProjectCubit>().getProjectFromWorkspaceUid(
          _auth.currentUser!.uid, widget.workspaceUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProjectModel> projects = snapshot.data!;
          List<ProjectModel> finishedProject = projects
              .where((project) => project.state.toString() == "finished")
              .toList();
          if (finishedProject.isEmpty) {
            return const NoProjectCard();
          }
          return ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: finishedProject.length,
            itemBuilder: (BuildContext context, int index) {
              if (widget.name.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.4,
                      motion: const StretchMotion(),
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: RawMaterialButton(
                              onPressed: () {
                                context
                                    .read<ProjectCubit>()
                                    .deleteProject(finishedProject[index].id!);
                              },
                              elevation: 2.0,
                              fillColor: Colors.red,
                              padding: EdgeInsets.all(15.sp),
                              shape: const CircleBorder(),
                              child: Icon(
                                Icons.delete,
                                size: 25.sp,
                                color: white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    child: MyProjectCard(
                      project: finishedProject[index],
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.project_detail,
                          arguments: {
                            'projectUid': finishedProject[index].id.toString(),
                            'workspaceUid': widget.workspaceUid,
                          },
                        );
                      },
                    ),
                  ),
                );
              } else if (finishedProject[index]
                  .name!
                  .toLowerCase()
                  .startsWith(widget.name)) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: MyProjectCard(
                    project: finishedProject[index],
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteName.project_detail,
                        arguments: {
                          'projectUid': finishedProject[index].id.toString(),
                          'workspaceUid': widget.workspaceUid,
                        },
                      );
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
