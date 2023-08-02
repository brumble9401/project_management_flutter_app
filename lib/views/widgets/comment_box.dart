import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCommentBox extends StatefulWidget {
  const MyCommentBox({super.key, this.controller, this.onPressed});

  final TextEditingController? controller;
  final Function()? onPressed;

  @override
  State<MyCommentBox> createState() => _MyCommentBoxState();
}

class _MyCommentBoxState extends State<MyCommentBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.comment_outlined),
            SizedBox(width: 20.w),
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: const InputDecoration(
                  hintText: 'Write a comment...',
                ),
              ),
            ),
            SizedBox(width: 20.w),
            ElevatedButton(
              onPressed: widget.onPressed,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
