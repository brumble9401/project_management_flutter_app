import 'package:flutter/material.dart';
import 'package:pma_dclv/theme/theme.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final Function() onPressed;
  final String title;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primary),
        minimumSize: MaterialStateProperty.all(const Size(400, 50)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
      ),
      child: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
