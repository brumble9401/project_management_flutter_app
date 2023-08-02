import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/data/models/authentication/register_model.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/authentication/auth_cubit.dart';
import 'package:pma_dclv/views/widgets/button/iconButton.dart';

import '../widget_tree.dart';
import '../widgets/button/button.dart';
import '../widgets/divider.dart';
import '../widgets/inputBox.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  RegisterModel userRegis = RegisterModel();

  void _onPressed() {
    print("asdasd");
  }

  void register() async {
    Map<String, dynamic> obj = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email": _emailController.text,
      "avatar": "",
    };
    await context
        .read<AuthCubit>()
        .firebaseRegister(obj, _emailController.text, _passwordController.text);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _password1Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 80.0,
            bottom: 20.0,
            right: 20,
            left: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: neutral_dark,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  InputBox(
                    label: "Email",
                    controller: _emailController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InputBox(
                    label: "First name",
                    controller: _firstNameController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InputBox(
                    label: "Last name",
                    controller: _lastNameController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InputBox(
                    label: "Password",
                    controller: _passwordController,
                    type: "password",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InputBox(
                    label: "Retype password",
                    controller: _password1Controller,
                    type: "password",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      // TODO: implement listener
                      if (state.authStatus == AuthStatus.registerSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyWidgetTree(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.authStatus == AuthStatus.loading) {
                        return Button(
                          title: "Sign Up",
                          onPressed: () {},
                        );
                      }
                      return Button(
                        title: "Sign Up",
                        onPressed: () {
                          register();
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const TextDivider(
                    title: "Or sign in with",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconBtn(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      IconBtn(
                        onPressed: () {},
                        icon: const Icon(Icons.safety_check),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      IconBtn(
                        onPressed: () {},
                        icon: const Icon(Icons.abc),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: neutral_grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: ascent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
