import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';

class InputBox extends StatefulWidget {
  const InputBox({
    super.key,
    this.label,
    this.icon,
    this.controller,
    this.type,
  });

  final TextEditingController? controller;
  final String? label;
  final String? icon;
  final String? type;

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            offset: Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.type == "password" ? true : false,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide.none,
          ),
          fillColor: white,
          filled: true,
          labelText: widget.label,
          labelStyle: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
