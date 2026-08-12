import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class QiblaInfoCards extends StatelessWidget {
  final String distanceText;

  const QiblaInfoCards({super.key, required this.distanceText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 55.w),
      child: Row(
        children: [
          Expanded(
            child: QiblaInfoCard(
              title: 'DISTANCE',
              value: distanceText,
              accent: const Color(0xff00695C),
            ),
          ),
          SizedBox(width: 15.w),
          const Expanded(
            child: QiblaInfoCard(
              title: 'COMPASS',
              value: 'Live\nSensor',
              accent: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class QiblaInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const QiblaInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 123.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13.r),
                bottomLeft: Radius.circular(13.r),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 9.sp,
                      letterSpacing: 1,
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18.sp,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
