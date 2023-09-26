import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/card/project/no_project_card.dart';

import '../../widgets/card/project_card.dart';

class MyAllProjects extends StatefulWidget {
  const MyAllProjects({
    super.key,
    required this.isLeader,
    required this.name,
    required this.workspaceUid,
  });

  final bool isLeader;
  final String name;
  final String workspaceUid;

  @override
  State<MyAllProjects> createState() => _MyAllProjectsState();
}

class _MyAllProjectsState extends State<MyAllProjects> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print(widget.isLeader);
    return StreamBuilder<List<ProjectModel>>(
      stream: context.read<ProjectCubit>().getProjectFromWorkspaceUid(
          _auth.currentUser!.uid, widget.workspaceUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProjectModel> projects = snapshot.data!;
          List<ProjectModel> unFinishedProjects = projects
              .where((project) => project.state.toString() == "inprogress")
              .toList();
          if (unFinishedProjects.isEmpty) {
            return const NoProjectCard();
          }
          return ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: unFinishedProjects.length,
            itemBuilder: (BuildContext context, int index) {
              if (widget.name.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      extentRatio: 0.4,
                      children: widget.isLeader == true
                          ? [
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      context
                                          .read<ProjectCubit>()
                                          .updateProjectStatus(
                                            unFinishedProjects[index].id!,
                                            'finished',
                                          );
                                    },
                                    elevation: 2.0,
                                    fillColor: primary,
                                    padding: EdgeInsets.all(15.sp),
                                    shape: const CircleBorder(),
                                    child: Icon(
                                      FontAwesomeIcons.check,
                                      size: 25.sp,
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      context
                                          .read<ProjectCubit>()
                                          .deleteProject(
                                            unFinishedProjects[index].id!,
                                          );
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
                            ]
                          : [],
                    ),
                    child: MyProjectCard(
                      project: unFinishedProjects[index],
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.project_detail,
                          arguments: {
                            'projectUid':
                                unFinishedProjects[index].id.toString(),
                            'workspaceUid': widget.workspaceUid,
                          },
                        );
                      },
                    ),
                  ),
                );
              } else if (unFinishedProjects[index]
                  .name!
                  .toLowerCase()
                  .startsWith(widget.name)) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: MyProjectCard(
                    project: unFinishedProjects[index],
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RouteName.project_detail,
                        arguments: {
                          'projectUid': unFinishedProjects[index].id.toString(),
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
