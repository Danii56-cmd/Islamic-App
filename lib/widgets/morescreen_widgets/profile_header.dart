import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 54.r,
              backgroundColor: context.primaryDark,
              child: Icon(Icons.person, size: 56.sp, color: Colors.white),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: context.accent,
                child: Icon(Icons.edit, size: 14.sp, color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          "Ahmad Abdullah",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: context.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "ahmed.abdullah@example.com",
          style: TextStyle(fontSize: 14.sp, color: context.textMuted),
        ),
      ],
    );
  }
}
