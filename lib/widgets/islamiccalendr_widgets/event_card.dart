import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/theme_extensions.dart';

class UpcomingEventCard extends StatelessWidget {
  final VoidCallback onReminderTap;

  const UpcomingEventCard({super.key, required this.onReminderTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 25.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45.w,
            bottom: -50.h,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: context.primaryLight.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Event',
                style: TextStyle(
                  color: context.textOnPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 9.h),
              Text(
                'Eid-al-Fitr is approaching in 1 day. '
                'Time for Zakat-al-Fitr.',
                style: TextStyle(
                  color: context.prayerCardText,
                  fontSize: 13.sp,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 17.h),
              ElevatedButton(
                onPressed: onReminderTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.accent,
                  foregroundColor: context.textPrimary,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                ),
                child: Text(
                  'Set Reminder',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
