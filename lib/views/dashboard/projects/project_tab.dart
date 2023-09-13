import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/theme.dart';

class MyProjectTab extends StatefulWidget {
  const MyProjectTab({
    super.key,
    required this.page,
    required this.onChangePage,
  });

  final Function onChangePage;
  final int page;

  @override
  State<MyProjectTab> createState() => _MyProjectTabState();
}

class _MyProjectTabState extends State<MyProjectTab> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {
              widget.onChangePage(0);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                widget.page == 0 ? primary : white,
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(10.w, 30.h),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(color: Colors.transparent),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.w),
                  ),
                ),
              ),
            ),
            child: Text(
              "Projects",
              style: TextStyle(
                color: widget.page == 0 ? white : neutral_grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {
              widget.onChangePage(1);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                widget.page == 1 ? primary : white,
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(10.w, 30.h),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(color: Colors.transparent),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.w),
                  ),
                ),
              ),
            ),
            child: Text(
              "Completed",
              style: TextStyle(
                color: widget.page == 1 ? white : neutral_grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}
