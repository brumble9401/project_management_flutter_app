import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';

class IconBtn extends StatefulWidget {
  const IconBtn({super.key, required this.icon, required this.onPressed});

  final Icon icon;
  final void Function()? onPressed;

  @override
  State<IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<IconBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: 40.w, // Set the desired width
        height: 40.w, // Set the desired height
        decoration: const BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
        child: widget.icon,
      ),
    );
    // );
  }
}
