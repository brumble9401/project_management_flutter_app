import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/views/home.dart';
import 'package:pma_dclv/views/widgets/button/iconButton.dart';

import '../../view-model/authentication/auth_cubit.dart';
import '../widgets/button/button.dart';
import '../widgets/divider.dart';
import '../widgets/inputBox.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLoginButtonPressed() async {
    context.read<AuthCubit>().firebaseLogin(
        _usernameController.text.trim(), _passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    "Sign In",
                    style: TextStyle(
                      color: neutral_dark,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InputBox(
                    label: "username",
                    controller: _usernameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputBox(
                    label: "password",
                    type: "password",
                    controller: _passwordController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot password ?",
                          style: TextStyle(
                            color: neutral_dark,
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state.authStatus == AuthStatus.authenticated) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                          (route) => false,
                        );
                      }
                      if (state.authStatus == AuthStatus.failed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.errorMessage.toString(),
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.authStatus == AuthStatus.loading) {
                        return const SizedBox(
                          height: 55,
                          child: FittedBox(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                  // color: AppColor.secondary,
                                  ),
                            ),
                          ),
                        );
                      }
                      return Button(
                        title: "Sign In",
                        onPressed: _onLoginButtonPressed,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const TextDivider(
                    title: "Or sign in with",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconBtn(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconBtn(
                        onPressed: () {},
                        icon: const Icon(Icons.safety_check),
                      ),
                      const SizedBox(
                        width: 20,
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
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: ascent,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
