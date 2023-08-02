import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';

class TextIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const TextIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: neutral_grey,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(width: 2.w),
          Icon(
            icon,
            size: 19.sp,
            color: neutral_grey,
          ),
        ],
      ),
    );
  }
}
