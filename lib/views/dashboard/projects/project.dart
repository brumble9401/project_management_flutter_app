import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/views/dashboard/projects/all_projects.dart';
import 'package:pma_dclv/views/dashboard/projects/completed_project.dart';
import 'package:pma_dclv/views/dashboard/projects/project_tab.dart';
import 'package:pma_dclv/views/widgets/appbar/center_title_appbar.dart';

import '../../../theme/theme.dart';
import '../../widgets/inputBox.dart';

class MyProjectView extends StatefulWidget {
  const MyProjectView({super.key});

  @override
  State<MyProjectView> createState() => _MyProjectViewState();
}

class _MyProjectViewState extends State<MyProjectView> {
  int _page = 0;
  String user_uid = FirebaseAuth.instance.currentUser!.uid;

  void onChangePage(index) {
    setState(() {
      _page = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
          child: Scaffold(
            appBar: MyCenterTitleAppBar(
              onPressed: () {
                Navigator.pop(context);
              },
              title: "Projects",
              hasIconButton: true,
            ),
            body: Container(
              decoration: const BoxDecoration(color: white),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Column(
                          children: [
                            const InputBox(label: "Search"),
                            SizedBox(
                              height: 17.w,
                            ),
                            MyProjectTab(
                              page: _page,
                              onChangePage: onChangePage,
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            StreamBuilder<List<ProjectModel>>(
                              stream: context
                                  .read<ProjectCubit>()
                                  .getProjectFromFirestore(user_uid),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<ProjectModel> projectList =
                                      snapshot.data!;
                                  if (projectList.isNotEmpty) {
                                    return _page == 0
                                        ? MyAllProjects(projects: projectList)
                                        : MyCompletedProjects(
                                            projects: projectList);
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
