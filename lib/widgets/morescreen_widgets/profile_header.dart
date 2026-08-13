import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 62.r,
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person, size: 65.sp, color: Colors.white),
            ),

            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.accent,
                child: Icon(Icons.edit, size: 14.sp, color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Text(
          "Ahmad Abdullah",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "ahmed.abdullah@example.com",
          style: TextStyle(fontSize: 14.sp, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
