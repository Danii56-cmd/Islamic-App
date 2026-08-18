import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class QiblaInfoCards extends StatelessWidget {
  final String distanceText;

  const QiblaInfoCards({super.key, required this.distanceText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: QiblaInfoCard(
              title: 'DISTANCE',
              value: distanceText,
              accentColor: const Color(0xFF004D40),
            ),
          ),
          SizedBox(width: 14.w),
          const Expanded(
            child: QiblaInfoCard(
              title: 'PRECISION',
              value: 'High\nAccuracy',
              accentColor: Color(0xFFC5A038),
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
  final Color accentColor;

  const QiblaInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border(
          left: BorderSide(color: accentColor, width: 4.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 17.sp,
              height: 1.25,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
