import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/theme.dart';
import '../button/iconButton.dart';

class MyCenterTitleAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyCenterTitleAppBar({
    super.key,
    required this.title,
    this.hasIconButton,
    this.onPressed,
  });

  final String title;
  final bool? hasIconButton;
  final void Function()? onPressed;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool hasButton = hasIconButton ?? false;

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      backgroundColor: white,
      centerTitle: false,
      shadowColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.chevron_left,
              color: neutral_dark,
              size: 19.sp,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: neutral_dark,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),
          hasButton
              ? IconBtn(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.plus,
                    size: 15,
                  ),
                )
              : const Text(""),
        ],
      ),
    );
  }
}
