import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/widgets/morescreen_widgets/reusable_card.dart';

class ReaderCustomizationCard extends StatelessWidget {
  const ReaderCustomizationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return MyCard(
      backgroundColor: AppColors.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_size, color: AppColors.primaryDark),
              SizedBox(width: 8.w),
              Text(
                "Reader Customization",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SMALL",
                style: TextStyle(
                  fontSize: 11.sp,
                  letterSpacing: 1,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                "NORMAL",
                style: TextStyle(
                  fontSize: 11.sp,
                  letterSpacing: 1,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                "LARGE",
                style: TextStyle(
                  fontSize: 11.sp,
                  letterSpacing: 1,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),

          Slider(
            value: 1,
            min: 0,
            max: 2,
            divisions: 2,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.textMuted.withValues(alpha: 0.2),
            onChanged: (value) {},
          ),
          // Internal Container
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.r),
              border: Border(
                left: BorderSide(color: AppColors.accent, width: 3.w),
              ),
            ),
            child: Text(
              '"The heart finds rest in\n'
              'the remembrance of the\n'
              'Divine."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              "— SAMPLE TEXT PREVIEW",
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
