import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';

import '../../../theme/theme.dart';

class MyWorkspaceCard extends StatefulWidget {
  const MyWorkspaceCard({super.key, this.onPressed, required this.workspace});

  final Function()? onPressed;
  final WorkspaceModel workspace;

  @override
  State<MyWorkspaceCard> createState() => _MyWorkspaceCardState();
}

class _MyWorkspaceCardState extends State<MyWorkspaceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90.h,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: neutral_lightgrey),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: const [
          BoxShadow(
            color: neutral_lightgrey,
            spreadRadius: 2,
            blurRadius: 9,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.zero,
          ),
          side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.transparent),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(25.w),
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
                  radius: 20.w,
                  backgroundImage: const AssetImage("assets/images/dog.jpg"),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              SizedBox(
                width: 200.w,
                child: Text(
                  widget.workspace.workspaceName.toString(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    color: neutral_dark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
