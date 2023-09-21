import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/data/models/workspaces/workspace.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/view-model/workspace/workspace_cubit.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/appbar/non_title_appbar.dart';

enum _MenuValues {
  addUser,
}

class WorkspaceDetail extends StatefulWidget {
  const WorkspaceDetail({super.key, required this.workspaceUid});

  final String workspaceUid;

  @override
  State<WorkspaceDetail> createState() => _WorkspaceDetailState();
}

class _WorkspaceDetailState extends State<WorkspaceDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
          child: Scaffold(
            appBar: MyNonTitleAppbar(
              onPressed: () => Navigator.pop(context),
              btn: Container(
                width: 40.w, // Set the desired width
                height: 40.w,
                decoration: const BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: PopupMenuButton<_MenuValues>(
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: _MenuValues.addUser,
                      child: Text('Add users'),
                    ),
                  ],
                  icon: Icon(
                    FontAwesomeIcons.plus,
                    color: white,
                    size: 15.sp,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case _MenuValues.addUser:
                        break;
                    }
                  },
                ),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: white,
              ),
              child: StreamBuilder<WorkspaceModel>(
                stream: context
                    .read<WorkspaceCubit>()
                    .getWorkspaceFromUid(widget.workspaceUid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WorkspaceModel workspace = snapshot.data!;
                    return Column(
                      children: [
                        Center(
                          child: Text(
                            workspace.workspaceName.toString(),
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: neutral_dark,
                            ),
                          ),
                        ),
                        // _buildUserList(),
                        StreamBuilder<List<UserModel>>(
                          stream: context
                              .read<UserCubit>()
                              .getUsersFromWorkspace(widget.workspaceUid),
                          builder: (context, userSnap) {
                            if (userSnap.hasData) {
                              List<UserModel> users = userSnap.data!;
                              return _buildUserList(
                                  users, workspace.workspaceLeaderId!);
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(List<UserModel> users, List<String> leaderUids) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextButton(
            icon: const Icon(
              Icons.person_2_outlined,
              color: neutral_dark,
            ),
            title: "Members (${users.length})",
            onPressed: () => Navigator.pushNamed(
              context,
              RouteName.workspaceMember,
              arguments: {
                'workspaceUid': widget.workspaceUid,
                'workspaceLeaderUid': leaderUids,
              },
            ),
          ),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              itemCount: users.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.h, right: 10.w),
                  child: Column(
                    children: [
                      Container(
                        width: 50.w,
                        decoration: const BoxDecoration(
                          color: neutral_grey,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 20.w,
                          backgroundImage: users[index].avatar == ''
                              ? const NetworkImage(
                                  'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg')
                              : NetworkImage(users[index].avatar!),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text("${users[index].lastName}"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String title;
  final Icon icon;
  final void Function()? onPressed;

  const CustomTextButton({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(
          const BorderSide(color: Colors.transparent),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.only(left: 0.0, right: 0.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              SizedBox(
                width: 10.w,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: neutral_dark,
                ),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            size: 20.sp,
            color: neutral_dark,
          ),
        ],
      ),
    );
  }
}
