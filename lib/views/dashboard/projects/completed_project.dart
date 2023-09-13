import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/views/widgets/card/project/no_project_card.dart';

import '../../routes/route_name.dart';
import '../../widgets/card/project_card.dart';

class MyCompletedProjects extends StatefulWidget {
  const MyCompletedProjects({
    super.key,
    required this.projects,
    required this.name,
  });

  final List<ProjectModel> projects;
  final String name;

  @override
  State<MyCompletedProjects> createState() => _MyCompletedProjectsState();
}

class _MyCompletedProjectsState extends State<MyCompletedProjects> {
  ScrollController _scrollController = ScrollController();
  late final List<ProjectModel> finishedProject = widget.projects
      .where((project) => project.state.toString() == "finished")
      .toList();

  @override
  Widget build(BuildContext context) {
    if(finishedProject.isEmpty){
      return const NoProjectCard();
    }
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: finishedProject.length,
      itemBuilder: (BuildContext context, int index) {
        if(widget.name.isEmpty) {
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
        } else if(finishedProject[index].name!.toLowerCase().startsWith(widget.name)) {
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
        } else {
          return Container();
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
