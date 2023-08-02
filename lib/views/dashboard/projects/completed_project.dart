import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';

import '../../routes/route_name.dart';
import '../../widgets/card/project_card.dart';

class MyCompletedProjects extends StatefulWidget {
  const MyCompletedProjects({
    super.key,
    required this.projects,
  });

  final List<ProjectModel> projects;

  @override
  State<MyCompletedProjects> createState() => _MyCompletedProjectsState();
}

class _MyCompletedProjectsState extends State<MyCompletedProjects> {
  ScrollController _scrollController = ScrollController();
  late final List<ProjectModel> finishedProject = widget.projects
      .where((project) => project.state.toString() == "true")
      .toList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: finishedProject.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: MyProjectCard(
            project: finishedProject[index],
            onPressed: () {
              Navigator.pushNamed(context, RouteName.project_detail,
                  arguments: finishedProject[index].id.toString());
            },
          ),
        );
      },
    );
  }
}
