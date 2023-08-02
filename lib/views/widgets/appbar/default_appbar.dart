import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/theme.dart';
import '../button/iconButton.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title, this.onTap});

  final Function()? onTap;
  final String title;

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
          IconBtn(
            onPressed: () {
              showPopupMenu(context);
            },
            icon: const Icon(
              FontAwesomeIcons.plus,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  void showPopupMenu(BuildContext context) {
    final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
    final appBarSize = appBarRenderBox.size;
    final screenHeight = MediaQuery.of(context).size.height;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        appBarSize.width - 50.0,
        appBarSize.height + kToolbarHeight,
        appBarSize.width - 10.0,
        screenHeight,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: ListTile(
            onTap: onTap,
            title: Text(
              'New project',
              style: TextStyle(color: neutral_dark, fontSize: 14.sp),
            ),
          ),
        ),
      ],
    );
  }
}
