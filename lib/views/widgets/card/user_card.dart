import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyUserCard extends StatelessWidget {
  const MyUserCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 30.w,
          backgroundImage: const AssetImage("assets/images/dog.png"),
          backgroundColor: Colors.transparent,
        ),
        Container(
          width: 170.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 3.w,
              ),
              Container(
                child: Text(
                  "Tran Hung Cuong",
                  style: TextStyle(
                    fontSize: 15.w,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "tranhungcuong0904@gmail.com",
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
          onPressed: () {},
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
  }
}
