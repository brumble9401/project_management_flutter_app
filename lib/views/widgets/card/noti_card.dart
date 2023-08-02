import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/theme.dart';

class MyNotificationCard extends StatelessWidget {
  const MyNotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Container(
        width: double.infinity,
        height: 80.h,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(10.h)),
          border: Border.all(color: neutral_lightgrey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 30.w,
              backgroundImage: AssetImage("assets/images/dog.png"),
              backgroundColor: Colors.transparent,
            ),
            Container(
              width: 150.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 3.w,
                  ),
                  Container(
                    child: Text(
                      "David Johnathan",
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Create new task",
                      style: TextStyle(
                        fontSize: 13.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.w,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 3.w,
                ),
                Container(
                  child: Text(
                    "10 mins ago",
                    style: TextStyle(
                      fontSize: 10.w,
                      color: neutral_grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  width: 11.w,
                  height: 11.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                  ),
                ),
                SizedBox(
                  height: 3.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
