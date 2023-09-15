import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/notification/notification_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyNotificationCard extends StatelessWidget {
  const MyNotificationCard({super.key, required this.notificationModel, required this.onPress});

  final NotificationModel notificationModel;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(notificationModel.createdDate!);
    final timeAgo = timeago.format(DateTime.now().subtract(difference), locale: 'en', );

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
        child: OutlinedButton(
          onPressed: onPress,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                Radius.circular(10.h),
                ),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      "${notificationModel.title.toString()} sent a message",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: neutral_dark,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      notificationModel.body.toString(),
                      style: TextStyle(
                        color: neutral_dark,
                        fontSize: 13.sp,
                        overflow: TextOverflow.ellipsis,
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
                  Text(
                    timeAgo.toString(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: neutral_grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 11.w,
                    height: 11.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notificationModel.read == "false" ? primary : white,
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
      ),
    );
  }
}
