import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pma_dclv/data/models/task/task_model.dart';

import '../../../theme/theme.dart';

class MyTaskCard extends StatefulWidget {
  const MyTaskCard({super.key, this.onPressed, this.task});

  final Function()? onPressed;
  final TaskModel? task;

  @override
  State<MyTaskCard> createState() => _MyTaskCardState();
}

class _MyTaskCardState extends State<MyTaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90.h,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50.w,
                decoration: const BoxDecoration(
                  color: neutral_grey,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 30.w,
                  backgroundImage: const AssetImage("assets/images/dog.jpg"),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      widget.task!.name.toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: neutral_dark,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 13.sp,
                        color: neutral_grey,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Deadline: ${DateFormat('yyyy-MM-dd').format(widget.task!.deadline!)}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: neutral_grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
