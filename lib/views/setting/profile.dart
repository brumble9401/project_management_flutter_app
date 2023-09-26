import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pma_dclv/data/models/user/user_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/files_upload/file_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/views/widgets/button/button.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        if (context.mounted) {
          await context
              .read<UploadCubit>()
              .uploadAvatar(File(pickedFile.path), pickedFile.name, userUid);
        }
        _showUploadAlert(true); // Show success alert
      } catch (error) {
        _showUploadAlert(false); // Show error alert
      }
    }
  }

  void _showUploadAlert(bool success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(success ? "Upload Successful" : "Upload Failed"),
          content: Text(success
              ? "Image uploaded successfully!"
              : "Image upload failed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            backgroundColor: white,
            centerTitle: true,
            shadowColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.chevron_left,
                    color: neutral_dark,
                    size: 19.sp,
                  ),
                ),
                Text(
                  "Profile",
                  style: TextStyle(
                    color: neutral_dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                Container(
                  width: 40.w,
                ),
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: white,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
              child: Container(
                decoration: const BoxDecoration(color: white),
                child: Center(
                  child: BlocListener<UserCubit, UserState>(
                    listener: (context, state) async {
                      if (state.userStatus == UserStatus.success) {
                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Update Information Completed Successfully!',
                          confirmBtnText: 'Yes',
                          confirmBtnColor: semantic_green,
                          onConfirmBtnTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                    child: StreamBuilder<UserModel>(
                      stream: context.read<UserCubit>().getUserFromUid(userUid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserModel user = snapshot.data!;

                          _firstNameController.text = user.firstName ?? '';
                          _lastNameController.text = user.lastName ?? '';

                          return Column(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.h),
                                          child: Container(
                                            // width: 160.sp,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: neutral_dark),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: neutral_lightgrey,
                                                  spreadRadius: 2,
                                                  blurRadius: 9,
                                                  offset: Offset(0,
                                                      3), // changes the position of the shadow
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              radius: 70.sp,
                                              backgroundImage: user.avatar == ''
                                                  ? const NetworkImage(
                                                      'https://img.myloview.com/posters/default-avatar-profile-icon-vector-social-media-user-photo-400-205577532.jpg')
                                                  : NetworkImage(user.avatar!),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 4.h,
                                          right: 10.w,
                                          child: IconButton(
                                            onPressed: () {
                                              _pickImage();
                                            },
                                            icon: const Icon(
                                              FontAwesomeIcons.camera,
                                              color: neutral_lightgrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    itemProfile(
                                        "First name",
                                        "${user.firstName}",
                                        _firstNameController),
                                    itemProfile("Last name", "${user.lastName}",
                                        _lastNameController),
                                    itemProfile1("Email", "${user.email}"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Button(
                                  onPressed: () {
                                    context.read<UserCubit>().updateUserInfo(
                                      userUid,
                                      {
                                        'last_name': _lastNameController.text,
                                        'first_name': _firstNameController.text,
                                      },
                                    );
                                  },
                                  title: 'Update',
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  itemProfile(String title, String content, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(color: neutral_lightgrey),
          boxShadow: const [
            BoxShadow(
              color: neutral_lightgrey,
              spreadRadius: 2,
              blurRadius: 9,
              offset: Offset(0, 3), // changes the position of the shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: neutral_dark,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 170.w,
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(
                    fontSize: 15.sp,
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

  itemProfile1(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(color: neutral_lightgrey),
          boxShadow: const [
            BoxShadow(
              color: neutral_lightgrey,
              spreadRadius: 2,
              blurRadius: 9,
              offset: Offset(0, 3), // changes the position of the shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: neutral_dark,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 170.w,
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 15.sp,
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
