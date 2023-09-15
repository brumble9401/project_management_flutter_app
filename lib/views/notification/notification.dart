import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/data/models/notification/notification_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/noti/notification.dart';
import 'package:pma_dclv/views/widgets/card/noti_card.dart';

class MyNotificationPage extends StatefulWidget {
  const MyNotificationPage({super.key});

  @override
  State<MyNotificationPage> createState() => _MyNotificationPageState();
}

class _MyNotificationPageState extends State<MyNotificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: white),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: white,
            centerTitle: false,
            shadowColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notification",
                  style: TextStyle(
                    color: neutral_dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
              ],
            ),
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
                  StreamBuilder<List<NotificationModel>>(
                    stream: context.read<NotificationCubit>().getNotificationHistory(_auth.currentUser!.uid),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        List<NotificationModel> noti = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: noti.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MyNotificationCard(
                              notificationModel: noti[index],
                              onPress: (){
                                context.read<NotificationCubit>().updateReadStatus(noti[index].uid.toString());
                              },
                            );
                          },
                        );
                      }
                      else if(snapshot.hasError){
                        print(snapshot.hasError);
                        return Container();
                      } else {
                        return Container();
                      }
                    },
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
