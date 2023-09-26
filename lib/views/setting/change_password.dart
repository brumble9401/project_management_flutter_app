import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/authentication/auth_cubit.dart';
import 'package:pma_dclv/views/widgets/inputBox.dart';
import 'package:quickalert/quickalert.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _changePassword(
      String email, String password, String newPassword) async {
    await context
        .read<AuthCubit>()
        .changePassword(email, password, newPassword);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: white,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Change Password',
            style: TextStyle(color: neutral_dark),
          ),
          backgroundColor: white,
          iconTheme: const IconThemeData(color: neutral_dark),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.h, bottom: 10.h),
                  child: Center(
                    child: SizedBox(
                      width: 130.w,
                      child: const Image(
                        image: AssetImage('assets/images/change-password.png'),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Change Password',
                  style: TextStyle(
                    color: neutral_dark,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                InputBox(
                  controller: _oldPasswordController,
                  label: 'Old password',
                  type: 'password',
                ),
                SizedBox(
                  height: 20.h,
                ),
                InputBox(
                  controller: _newPasswordController,
                  label: 'New password',
                  type: 'password',
                ),
                SizedBox(
                  height: 20.h,
                ),
                InputBox(
                  controller: _confirmNewPasswordController,
                  label: 'Confirm new password',
                  type: 'password',
                ),
                SizedBox(height: 20.h),
                BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) async {
                    if (state.authStatus == AuthStatus.success) {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: 'Change password Completed Successfully!',
                        confirmBtnText: 'OK',
                        confirmBtnColor: semantic_green,
                        onConfirmBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                    } else if (state.authStatus == AuthStatus.failed) {
                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Change password Failed!',
                        confirmBtnText: 'OK',
                        confirmBtnColor: Colors.red,
                        onConfirmBtnTap: () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () => _changePassword(
                      _auth.currentUser!.email.toString(),
                      _oldPasswordController.text,
                      _newPasswordController.text,
                    ),
                    child: const Text('Change Password'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
