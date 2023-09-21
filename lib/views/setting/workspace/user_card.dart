import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/user/user_model.dart';
import '../../../theme/theme.dart';

class UserBox extends StatelessWidget {
  final UserModel user;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLeader;

  const UserBox({
    Key? key,
    required this.user,
    required this.isSelected,
    required this.onTap,
    required this.isLeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          border: Border.all(color: isSelected ? primary : neutral_lightgrey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.w,
                  decoration: const BoxDecoration(
                    color: neutral_grey,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 30.w,
                    backgroundImage: user.avatar != ''
                        ? NetworkImage(user.avatar.toString())
                        : const NetworkImage(
                            'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150.w,
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
                      width: 150.w,
                      child: Text(
                        "${user.email}",
                        style: const TextStyle(
                          color: neutral_grey,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              isLeader == true ? 'Leader' : 'Member',
              style: TextStyle(
                fontSize: 14.sp,
                color: isLeader == true ? ascent : primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
