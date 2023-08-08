import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/theme.dart';

class NoTaskCard extends StatefulWidget {
  const NoTaskCard({super.key});

  @override
  State<NoTaskCard> createState() => _NoTaskCardState();
}

class _NoTaskCardState extends State<NoTaskCard> {
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
      child: Padding(
        padding: EdgeInsets.all(25.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                "There is no task",
                style: TextStyle(
                  fontSize: 16.sp,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: neutral_grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
