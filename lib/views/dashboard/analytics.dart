import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/views/dashboard/charts/bar_chart/week_chart.dart';
import 'package:pma_dclv/views/dashboard/charts/line_chart/month_chart.dart';

class MyAnalytics extends StatefulWidget {
  const MyAnalytics({super.key});

  @override
  State<MyAnalytics> createState() => _MyAnalyticsState();
}

class _MyAnalyticsState extends State<MyAnalytics> {
  List<double> weekData = [
    10,
    20,
    31,
    5,
    34,
    25,
    16,
  ];

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
        SizedBox(height: 20.h),
        Container(
          height: 150.h,
          decoration: const BoxDecoration(
            color: white,
          ),
          child: WeekChart(weekData: weekData,),
        ),
        SizedBox(height: 15.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: const BoxDecoration(
                color: ascent,
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "100 tasks in progress",
              style: TextStyle(
                fontSize: 10.sp,
                color: neutral_dark,
              ),
            ),
            SizedBox(width: 20.w,),
            Container(
              width: 10.w,
              height: 10.w,
              decoration: const BoxDecoration(
                color: primary,
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "10 tasks done",
              style: TextStyle(
                fontSize: 10.sp,
                color: neutral_dark,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
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
        SizedBox(height: 20.h),
        Container(
          height: 150.h,
          decoration: const BoxDecoration(
            color: white,
          ),
          child: MonthChart(),
        ),
        SizedBox(height: 15.h,),
      ],
    );
  }
}
