import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/task/task_model.dart';
import '../../../../theme/theme.dart';

class MyTaskCard2 extends StatefulWidget {
  const MyTaskCard2(
      {super.key, required this.task, this.onPressed, this.onLongPressed});

  final TaskModel task;
  final Function()? onPressed;
  final Function()? onLongPressed;

  @override
  State<MyTaskCard2> createState() => _MyTaskCard2State();
}

class _MyTaskCard2State extends State<MyTaskCard2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
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
        onLongPress: widget.onLongPressed,
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
          padding: EdgeInsets.all(12.w),
          child: SizedBox(
            width: 100.w,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.name.toString(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: neutral_dark,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                color: neutral_dark,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              widget.task.state == "finished"
                                  ? "Done"
                                  : "In progress",
                              style: TextStyle(
                                color: widget.task.state == "finished"
                                    ? semantic_green
                                    : ascent,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deadline",
                              style: TextStyle(
                                color: primary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              DateFormat.yMMMd().format(DateTime.parse(
                                  widget.task.deadline.toString())),
                              style: TextStyle(
                                color: neutral_grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Priority",
                              style: TextStyle(
                                color: ascent,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              "High",
                              style: TextStyle(
                                color: neutral_grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
