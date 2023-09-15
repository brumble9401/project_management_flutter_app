import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/comment/comment_model.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';

class MyCommentCard extends StatefulWidget {
  const MyCommentCard({super.key, required this.comment});

  final CommentModel comment;

  @override
  State<MyCommentCard> createState() => _MyCommentCardState();
}

class _MyCommentCardState extends State<MyCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        // height: 70.h,
        decoration: const BoxDecoration(
          color: white,
          border: Border(
            bottom: BorderSide(
              color: neutral_lightgrey, // Set the desired border color
              width: 1, // Set the desired border width
            ),
          ),
        ),
        child: StreamBuilder<UserModel>(
            stream: context
                .read<UserCubit>()
                .getUserFromUid(widget.comment.userUid.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel user = snapshot.data!;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50.w,
                      decoration: const BoxDecoration(
                        color: neutral_grey,
                        shape: BoxShape.circle,
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
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "${user.firstName} ${user.lastName}",
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
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            "${widget.comment.content}",
                            style: const TextStyle(
                              color: neutral_grey,
                              // overflow: TextOverflow.
                            ),
                            softWrap: true,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
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
            }),
      ),
    );
  }
}
