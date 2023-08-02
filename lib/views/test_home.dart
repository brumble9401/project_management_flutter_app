import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/views/routes/route_name.dart';
import 'package:pma_dclv/views/widgets/appbar/default_appbar.dart';
import 'package:pma_dclv/views/widgets/button/button.dart';
import 'package:pma_dclv/views/widgets/button/text_icon_button.dart';
import 'package:pma_dclv/views/widgets/card/user_card.dart';

import '../theme/theme.dart';
import '../view-model/authentication/auth_cubit.dart';

class MyTestHomePage extends StatefulWidget {
  const MyTestHomePage({super.key});

  @override
  State<MyTestHomePage> createState() => _MyTestHomePageState();
}

class _MyTestHomePageState extends State<MyTestHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
      decoration: const BoxDecoration(
        color: white,
      ),
      child: Scaffold(
        appBar: MyAppBar(
          title: "Setting",
        ),
        body: Container(
          decoration: const BoxDecoration(color: white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Container(
                      width: double.infinity,
                      height: 70.h,
                      decoration: BoxDecoration(
                        // border: Border.all(color: neutral_lightgrey),
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                      ),
                      child: MyUserCard(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Workspace",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextIconButton(
                          icon: Icons.change_circle_outlined,
                          text: "Change",
                          onPressed: () {
                            print("Change");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Button(
                onPressed: () {
                  context.read<AuthCubit>().firebaseSignOut();
                  Navigator.pushReplacementNamed(context, RouteName.signin);
                },
                title: "Sign out",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
