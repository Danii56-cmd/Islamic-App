import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.dark_mode_outlined,
                  color: AppColors.accent,
                  size: 28.sp,
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17.r,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.wb_sunny_outlined,
                          size: 16.sp,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.dark_mode_outlined,
                        size: 16.sp,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.h),
            Text(
              "Appearance",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 3.h),
            Text(
              "Switch between light and dark themes",
              style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
