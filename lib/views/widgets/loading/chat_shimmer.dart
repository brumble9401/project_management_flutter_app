import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../theme/theme.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: neutral_lightgrey,
      highlightColor: neutral_grey,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5, // Adjust the number of shimmering items
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30.w,
              backgroundColor: Colors.white,
            ),
            title: Container(
              width: double.infinity,
              height: 12.h,
              color: Colors.white,
            ),
            subtitle: Container(
              width: 120.w,
              height: 10.h,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
