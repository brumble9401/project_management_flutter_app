import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/views/routes/route_name.dart';

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
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.projects.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: MyProjectCard(
            project: widget.projects[index],
            onPressed: () {
              Navigator.pushNamed(context, RouteName.project_detail,
                  arguments: widget.projects[index].id.toString());
            },
          ),
        );
      },
    );
  }
}
