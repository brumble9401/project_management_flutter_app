import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/dashboard/projects/all_projects.dart';
import 'package:pma_dclv/views/dashboard/projects/completed_project.dart';
import 'package:pma_dclv/views/dashboard/projects/project_tab.dart';
import 'package:pma_dclv/views/widgets/appbar/center_title_appbar.dart';
import 'package:pma_dclv/views/widgets/bottomModalSheet/project_create_bottom_sheet.dart';

import '../../../theme/theme.dart';

enum _MenuValues {
  createProject,
}

class MyProjectView extends StatefulWidget {
  const MyProjectView({super.key, required this.workspaceUid});

  final String workspaceUid;

  @override
  State<MyProjectView> createState() => _MyProjectViewState();
}

class _MyProjectViewState extends State<MyProjectView> {
  int _page = 0;
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  String name = "";
  bool isLeader = false;

  void onChangePage(index) {
    setState(() {
      _page = index;
    });
  }

  void checkLeader(String workspaceUid) async {
    bool check =
        await context.read<WorkspaceCubit>().checkLeader(workspaceUid, userUid);
    setState(() {
      isLeader = check;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLeader(widget.workspaceUid);
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
              btn: isLeader == false
                  ? SizedBox(
                      width: 40.w, // Set the desired width
                      height: 40.w,
                    )
                  : Container(
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
                        offset: const Offset(-15, 20),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.w))),
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: _MenuValues.createProject,
                            child: Text('New project'),
                          ),
                        ],
                        icon: Icon(
                          FontAwesomeIcons.plus,
                          color: white,
                          size: 15.sp,
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case _MenuValues.createProject:
                              showModalBottomSheet(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (BuildContext context) =>
                                    MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => WorkspaceCubit(),
                                    ),
                                    BlocProvider(
                                      create: (context) => ProjectCubit(),
                                    ),
                                    BlocProvider(
                                      create: (context) => UserCubit(),
                                    ),
                                  ],
                                  child: MyProjectBottomModalSheet(
                                    title: "Create Project",
                                    workspaceUid:
                                        widget.workspaceUid.toString(),
                                  ),
                                ),
                              );
                              break;
                          }
                        },
                      ),
                    ),
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
                            Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(color: neutral_lightgrey),
                                boxShadow: const [
                                  BoxShadow(
                                    color: neutral_lightgrey,
                                    spreadRadius: 2,
                                    blurRadius: 9,
                                    offset: Offset(0,
                                        3), // changes the position of the shadow
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                onChanged: (value) => setState(() {
                                  name = value;
                                }),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: white,
                                  filled: true,
                                  labelText: "search",
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
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
                            _page == 0
                                ? BlocProvider(
                                    create: (context) => ProjectCubit(),
                                    child: MyAllProjects(
                                      isLeader: isLeader,
                                      name: name,
                                      workspaceUid: widget.workspaceUid,
                                    ),
                                  )
                                : BlocProvider(
                                    create: (context) => ProjectCubit(),
                                    child: MyCompletedProjects(
                                      name: name,
                                      workspaceUid: widget.workspaceUid,
                                    ),
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
