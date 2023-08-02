import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/views/widgets/appbar/default_appbar.dart';
import 'package:pma_dclv/views/widgets/card/noti_card.dart';

class MyNotificationPage extends StatefulWidget {
  const MyNotificationPage({super.key});

  @override
  State<MyNotificationPage> createState() => _MyNotificationPageState();
}

class _MyNotificationPageState extends State<MyNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: white),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
        child: Scaffold(
          appBar: const MyAppBar(
            title: "Notification",
          ),
          body: Container(
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            decoration: const BoxDecoration(color: white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.comment,
                              color: neutral_grey,
                              size: 21.sp,
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Text(
                              "Mark as read all",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: neutral_grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text(
                              "Delete all",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: ascent,
                              ),
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Icon(
                              FontAwesomeIcons.trash,
                              color: ascent,
                              size: 16.sp,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const MyNotificationCard(),
                  const MyNotificationCard(),
                  const MyNotificationCard(),
                  const MyNotificationCard(),
                  const MyNotificationCard(),
                  const MyNotificationCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
