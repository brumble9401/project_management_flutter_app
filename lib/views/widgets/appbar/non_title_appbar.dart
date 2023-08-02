import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/theme.dart';
import '../button/iconButton.dart';

class MyNonTitleAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyNonTitleAppbar({
    super.key,
    // required this.title,
    this.hasIconButton,
    this.onPressed,
    required this.menuList,
  });

  // final String title;
  final bool? hasIconButton;
  final void Function()? onPressed;
  final List<PopupMenuEntry<String>> menuList;

  @override
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
          hasButton
              ? IconBtn(
                  onPressed: () => showPopupMenu(context),
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
      items: menuList,
    );
  }
}
