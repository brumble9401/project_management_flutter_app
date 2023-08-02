import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/chat/chat_room.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';

class MyChatCard extends StatefulWidget {
  const MyChatCard({super.key, this.onPressed, required this.chatRoom});

  final Function()? onPressed;
  final ChatRoom chatRoom;

  @override
  State<MyChatCard> createState() => _MyChatCardState();
}

class _MyChatCardState extends State<MyChatCard> {
  final _auth = FirebaseAuth.instance;

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
                borderRadius: BorderRadius.circular(10.h),
              ),
            ),
          ),
          child: StreamBuilder<UserModel>(
            stream: context.read<UserCubit>().getUserFromUid(
                  widget.chatRoom.users![0] == _auth.currentUser!.uid
                      ? widget.chatRoom.users![1]
                      : widget.chatRoom.users![0],
                ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
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
                              snapshot.data!.lastName! +
                                  ' ' +
                                  snapshot.data!.firstName!,
                              style: TextStyle(
                                fontSize: 15.w,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: neutral_dark,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "asdasdasd",
                              style: TextStyle(
                                fontSize: 13.sp,
                                overflow: TextOverflow.ellipsis,
                                color: neutral_dark,
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
                          width: 11.w,
                          height: 11.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary,
                          ),
                        ),
                        Container(
                          child: Text(
                            "10 mins",
                            style: TextStyle(
                              fontSize: 10.w,
                              color: neutral_grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.w,
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
