import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';
import 'package:pma_dclv/view-model/tasks/task_cubit.dart';
import 'package:pma_dclv/views/dashboard/tasks/all_tasks.dart';
import 'package:pma_dclv/views/dashboard/tasks/completed_tasks.dart';
import 'package:pma_dclv/views/dashboard/tasks/task_tab.dart';
import 'package:pma_dclv/views/widgets/appbar/center_title_appbar.dart';
import 'package:pma_dclv/views/widgets/card/task/no_task_card.dart';

import '../../../theme/theme.dart';
import '../../widgets/inputBox.dart';

class MyTaskView extends StatefulWidget {
  const MyTaskView({super.key, required this.workspaceUid});

  final String workspaceUid;

  @override
  State<MyTaskView> createState() => _MyTaskViewState();
}

class _MyTaskViewState extends State<MyTaskView> {
  int _page = 0;
  String user_uid = "";
  String name = "";


  void getUserId() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          user_uid = user.uid;
        });
      }
    });
  }

  void onChangePage(index) {
    setState(() {
      _page = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
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
              title: "Tasks",
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
                                    offset: Offset(
                                        0, 3), // changes the position of the shadow
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
                            MyTaskTab(
                              page: _page,
                              onChangePage: onChangePage,
                            ),
                            SizedBox(
                              height: 17.w,
                            ),
                            StreamBuilder<List<TaskModel>>(
                              stream: context
                                  .read<TaskCubit>()
                                  .getAllTaskFromWorkspace(user_uid, widget.workspaceUid),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<TaskModel> tasks = snapshot.data!;
                                  if (tasks.isNotEmpty) {
                                    return _page == 0
                                        ? MyAllTasks(
                                            tasks: tasks,
                                            name: name,
                                          )
                                        : MyCompletedTasks(
                                            tasks: tasks,
                                            name: name,
                                          );
                                  } else {
                                    return const NoTaskCard();
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
