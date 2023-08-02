import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/projects/project_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/views/dashboard/add_users/user_card.dart';

class MyAddUserPage extends StatefulWidget {
  const MyAddUserPage({super.key, required this.ids});

  final List<String?> ids;

  @override
  State<MyAddUserPage> createState() => _MyAddUserPageState();
}

class _MyAddUserPageState extends State<MyAddUserPage> {
  String name = "";
  List<String> selectedUsers = [];

  void addUser() async {
    await context
        .read<ProjectCubit>()
        .addUserToCollection(selectedUsers, widget.ids[1].toString());
  }

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
                  TextButton(
                    onPressed: () {
                      addUser();
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  )
                ],
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    // width: 400.h,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: neutral_lightgrey),
                      boxShadow: const [
                        BoxShadow(
                          color: neutral_lightgrey,
                          spreadRadius: 2,
                          blurRadius: 9,
                          offset: Offset(
                              0, 3), // changes the position of the shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      // controller: widget.controller,
                      // obscureText: widget.type == "password" ? true : false,
                      onChanged: (value) => setState(() {
                        name = value;
                      }),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: white,
                        filled: true,
                        labelText: "search",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  StreamBuilder<List<UserModel>>(
                    stream: context
                        .read<UserCubit>()
                        .getUsersFromWorkspace(widget.ids[0].toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<UserModel> users = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: ((context, index) {
                            if (name.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: UserBox(
                                  user: users[index],
                                  isSelected: selectedUsers
                                      .contains(users[index].id.toString()),
                                  onTap: () {
                                    setState(() {
                                      if (selectedUsers.contains(
                                          users[index].id.toString())) {
                                        selectedUsers
                                            .remove(users[index].id.toString());
                                      } else {
                                        selectedUsers
                                            .add(users[index].id.toString());
                                      }
                                    });
                                  },
                                ),
                              );
                            } else if (users[index]
                                .firstName
                                .toString()
                                .toLowerCase()
                                .startsWith(name.toLowerCase())) {
                              return Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: UserBox(
                                  user: users[index],
                                  isSelected: selectedUsers
                                      .contains(users[index].id.toString()),
                                  onTap: () {
                                    setState(() {
                                      if (selectedUsers.contains(
                                          users[index].id.toString())) {
                                        selectedUsers
                                            .remove(users[index].id.toString());
                                      } else {
                                        selectedUsers
                                            .add(users[index].id.toString());
                                      }
                                    });
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
