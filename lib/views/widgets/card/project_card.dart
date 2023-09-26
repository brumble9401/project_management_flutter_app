import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma_dclv/data/models/project/project_model.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';
import 'package:pma_dclv/view-model/tasks/task_cubit.dart';

import '../../../theme/theme.dart';

class MyProjectCard extends StatefulWidget {
  const MyProjectCard({
    super.key,
    this.project,
    this.onPressed,
  });

  final ProjectModel? project;
  final Function()? onPressed;

  @override
  State<MyProjectCard> createState() => _MyProjectCardState();
}

class _MyProjectCardState extends State<MyProjectCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: neutral_lightgrey),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: const [
          BoxShadow(
            color: neutral_lightgrey,
            spreadRadius: 2,
            blurRadius: 9,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.zero,
          ),
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.transparent),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.project!.name.toString(),
                    style: TextStyle(
                      color: neutral_dark,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 14.sp,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd')
                        .format(widget.project!.createdDate!)
                        .toString(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: neutral_grey,
                    ),
                  ),
                  Image.asset(
                    'assets/icons/arrow.png',
                    fit: BoxFit.cover,
                    scale: 3.w,
                  ),
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 14.sp,
                    color: primary,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd')
                        .format(widget.project!.deadline!)
                        .toString(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: primary,
                    ),
                  ),
                ],
              ),
              StreamBuilder<List<TaskModel>>(
                  stream: context
                      .read<TaskCubit>()
                      .getTaskFromProjectUid(widget.project!.id.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<TaskModel> tasks = snapshot.data!;
                      if (tasks.length != 0) {
                        final finishTasks = tasks
                            .where((task) => task.state == "finished")
                            .toList();
                        final unFinishedTasks = tasks
                            .where((task) => task.state == "inprogress")
                            .toList();
                        final double percentage =
                            finishTasks.length / tasks.length * 100;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${percentage.round()}%",
                              style: TextStyle(
                                color: neutral_dark,
                                fontSize: 11.sp,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 160.w,
                                height: 5.h,
                                child: LinearProgressIndicator(
                                  value: percentage / 100, // percent filled
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          primary),
                                  backgroundColor: neutral_lightgrey,
                                ),
                              ),
                            ),
                            Text(
                              "${finishTasks.length}/${tasks.length} tasks",
                              style: TextStyle(
                                color: neutral_dark,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "0%",
                              style: TextStyle(
                                color: neutral_dark,
                                fontSize: 11.sp,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 160.w,
                                height: 5.h,
                                child: const LinearProgressIndicator(
                                  value: 0, // percent filled
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(primary),
                                  backgroundColor: neutral_lightgrey,
                                ),
                              ),
                            ),
                            Text(
                              "0/0 tasks",
                              style: TextStyle(
                                color: neutral_dark,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      return Container();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
