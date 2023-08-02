import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pma_dclv/theme/theme.dart';

class MyImageAddCard extends StatefulWidget {
  const MyImageAddCard({super.key, this.onPressed});

  final Function()? onPressed;

  @override
  State<MyImageAddCard> createState() => _MyImageAddCardState();
}

class _MyImageAddCardState extends State<MyImageAddCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: neutral_lightgrey,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
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
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.w),
            ),
          ))),
          child: const Icon(
            FontAwesomeIcons.plus,
            color: neutral_grey,
          )), // Add your content here
    );
  }
}
