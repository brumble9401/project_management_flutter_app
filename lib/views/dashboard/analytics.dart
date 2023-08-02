import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';

class MyAnalytics extends StatefulWidget {
  const MyAnalytics({super.key});

  @override
  State<MyAnalytics> createState() => _MyAnalyticsState();
}

class _MyAnalyticsState extends State<MyAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 8.h,
            bottom: 8.h,
          ),
          decoration: const BoxDecoration(
            color: white,
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/icons/Project.png",
                scale: 3.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                "Task productivity",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: neutral_dark,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 6.h,
            bottom: 6.h,
          ),
          child: Text(
            "Tasks in 7 days",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: neutral_dark,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 6.h,
            bottom: 6.h,
          ),
          child: Text(
            "Tasks in in this month",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: neutral_dark,
            ),
          ),
        ),
      ],
    );
  }
}
