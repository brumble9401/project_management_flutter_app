import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';

class MyUserCard extends StatelessWidget {
  final String userUid;

  const MyUserCard({
    super.key,
    required this.userUid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: context.read<UserCubit>().getUserFromUid(userUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel user = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 30.w,
                backgroundImage: user.avatar == ''
                    ? const NetworkImage(
                        'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg')
                    : NetworkImage(user.avatar!),
                backgroundColor: Colors.transparent,
              ),
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
                      "${user.firstName} ${user.lastName}",
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      child: Text(
                        "${user.email}",
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
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.profile);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.w),
                      ),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(60.w, 35.h),
                  ),
                ),
                child: const Text("Edit"),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
