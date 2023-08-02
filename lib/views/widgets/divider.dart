import 'package:flutter/material.dart';
import 'package:pma_dclv/theme/theme.dart';

class TextDivider extends StatelessWidget {
  final String title;

  const TextDivider({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: neutral_grey,
            thickness: 1,
          ),
        ), // Set the desired color for the divider
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0), // Set the desired padding around the text
          child: Text(
            title,
            style: const TextStyle(
              color: neutral_grey,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ), // Set the desired color for the text
          ),
        ),
        const Expanded(
          child: Divider(
            color: neutral_grey,
            thickness: 1,
          ),
        ), // Set the desired color for the divider
      ],
    );
  }
}
