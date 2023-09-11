import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/user/user_model.dart';
import '../../../theme/theme.dart';

class UserBox extends StatelessWidget {
  final UserModel user;
  final bool isSelected;
  final VoidCallback onTap;

  const UserBox({
    Key? key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          border: Border.all(color: isSelected ? primary : neutral_lightgrey),
        ),
        child: Row(
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
                    'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg'
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              width: 12.w,
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
      ),
    );
  }
}
