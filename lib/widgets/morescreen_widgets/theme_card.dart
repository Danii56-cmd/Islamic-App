import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class ThemeCard extends StatefulWidget {
  const ThemeCard({super.key});

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.dark_mode_outlined,
                color: AppColors.accent,
                size: 28.sp,
              ),

              const Spacer(),

              // Theme Switch
              GestureDetector(
                onTap: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 86.w,
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.primaryDark
                        : AppColors.textMuted.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 6.w),
                            child: Icon(
                              Icons.wb_sunny_outlined,
                              size: 16.sp,
                              color: isDarkMode
                                  ? AppColors.textMuted
                                  : AppColors.primaryDark,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Icon(
                              Icons.dark_mode_outlined,
                              size: 16.sp,
                              color: isDarkMode
                                  ? Colors.white
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),

                      // Sliding circle
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: isDarkMode
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDarkMode
                                ? Icons.dark_mode_outlined
                                : Icons.wb_sunny_outlined,
                            size: 16.sp,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Text(
            "Appearance",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            isDarkMode
                ? "Dark theme is enabled"
                : "Switch between light and dark themes",
            style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
