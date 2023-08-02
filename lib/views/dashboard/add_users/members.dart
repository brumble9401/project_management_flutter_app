import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/views/dashboard/add_users/user_card.dart';

class MyMemberPage extends StatefulWidget {
  const MyMemberPage({super.key, required this.uids});

  final List<String> uids;

  @override
  State<MyMemberPage> createState() => _MyMemberPageState();
}

class _MyMemberPageState extends State<MyMemberPage> {
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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              backgroundColor: white,
              centerTitle: false,
              shadowColor: Colors.transparent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      color: neutral_dark,
                      size: 19.sp,
                    ),
                  ),
                  Text(
                    "Members",
                    style: TextStyle(
                      color: neutral_dark,
                      fontSize: 20.sp,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // addUser();
                      // Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  )
                ],
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: white,
              ),
              // child: ListView.builder(),
              child: StreamBuilder<List<UserModel>>(
                stream:
                    context.read<UserCubit>().getListofUserFromUid(widget.uids),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<UserModel> users = snapshot.data!;
                    print(users);
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: UserBox(
                            user: users[index],
                            isSelected: false,
                            onTap: () {},
                          ),
                        );
                      },
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
}
