import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/card/project/no_project_card.dart';

import '../../widgets/card/project_card.dart';

class MyAllProjects extends StatefulWidget {
  const MyAllProjects({
    super.key,
    required this.projects,
  });

  final List<ProjectModel> projects;

  @override
  State<MyAllProjects> createState() => _MyAllProjectsState();
}

class _MyAllProjectsState extends State<MyAllProjects> {
  final ScrollController _scrollController = ScrollController();
  late final List<ProjectModel> projects = widget.projects
      .where((project) => project.state.toString() == "inprogress")
      .toList();

  @override
  Widget build(BuildContext context) {
    if(projects.isEmpty){
      return const NoProjectCard();
    } else {
      return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: projects.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: MyProjectCard(
            project: projects[index],
            onPressed: () {
              Navigator.pushNamed(context, RouteName.project_detail,
                  arguments: projects[index].id.toString());
            },
          ),
        );
      },
    );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
