import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/chat/chat_room.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    final difference = DateTime.now().difference(widget.chatRoom.createdDate!);
    final timeAgo = timeago.format(DateTime.now().subtract(difference), locale: 'en', );

    return Container(
      width: double.infinity,
      height: 70.h,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: neutral_grey),
                    ),
                    child: CircleAvatar(
                      radius: 30.w,
                      backgroundImage: snapshot.data!.avatar == ''
                          ? const NetworkImage(
                              'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg')
                          : NetworkImage(snapshot.data!.avatar!),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 170.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 3.w,
                        ),
                        Text(
                          '${snapshot.data!.firstName!} ${snapshot.data!.lastName!}',
                          style: TextStyle(
                            fontSize: 15.w,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: neutral_dark,
                          ),
                        ),
                        Text(
                          widget.chatRoom.lastMess.toString(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            overflow: TextOverflow.ellipsis,
                            color: widget.chatRoom.sender != _auth.currentUser!.uid && widget.chatRoom.read == "false" ? neutral_dark : neutral_grey,
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.chatRoom.sender != _auth.currentUser!.uid && widget.chatRoom.read == "false" ? primary : white,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 10.w,
                          color: neutral_grey,
                          overflow: TextOverflow.ellipsis,
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
    );
  }
}
