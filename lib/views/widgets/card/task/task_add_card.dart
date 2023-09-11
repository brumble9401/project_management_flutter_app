import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/view-model/tasks/task_cubit.dart';
import 'package:pma_dclv/view-model/user/user_cubit.dart';
import 'package:pma_dclv/views/widgets/bottomModalSheet/bottom_modal_sheet.dart';

class MyTaskAddCard extends StatefulWidget {
  const MyTaskAddCard({super.key, this.onPressed, required this.projectUid, required this.workspaceUid});

  final Function()? onPressed;
  final String projectUid;
  final String workspaceUid;

  @override
  State<MyTaskAddCard> createState() => _MyTaskAddCardState();
}

class _MyTaskAddCardState extends State<MyTaskAddCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 150.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: neutral_lightgrey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        color: white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
          onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            context: context,
            builder: (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => TaskCubit(),
                ),
                BlocProvider(
                  create: (context) => UserCubit(),
                ),
              ],
              child: MyBottomModalSheet(
                title: "Create Task",
                projectId: widget.projectUid,
                workspaceId: widget.workspaceUid,
              ),
            ),
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ))),
          child: const Icon(
            FontAwesomeIcons.plus,
            color: neutral_grey,
          )), // Add your content here
    );
  }
}
