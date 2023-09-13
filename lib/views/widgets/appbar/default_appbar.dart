import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/theme.dart';
import '../button/iconButton.dart';


enum _MenuValues {
  page2,
  settings,
  chickens,
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title, this.onTap, required this.btn});

  final Function()? onTap;
  final String title;
  final Widget btn;


  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: white,
      centerTitle: false,
      shadowColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: neutral_dark,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),
          btn,
        ],
      ),
    );
  }
}
