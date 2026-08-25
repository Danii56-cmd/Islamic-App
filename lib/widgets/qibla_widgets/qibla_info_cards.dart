import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/theme_extensions.dart';

class QiblaInfoCards extends StatelessWidget {
  final String distanceText;
  final double deviceHeading;
  final bool isAligned;

  const QiblaInfoCards({
    super.key,
    required this.distanceText,
    required this.deviceHeading,
    this.isAligned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: QiblaInfoCard(
              title: 'DISTANCE TO KAABA',
              value: distanceText,
              accentColor: const Color(0xFF004D40),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: QiblaInfoCard(
              title: 'PHONE HEADING',
              value: '${deviceHeading.round()}°',
              subtitle: isAligned ? 'Aligned with Kaaba' : 'Turn towards Qibla',
              accentColor: isAligned ? const Color(0xFF00796B) : const Color(0xFFC5A038),
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
  final String? subtitle;
  final Color accentColor;

  const QiblaInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
              fontSize: 9.sp,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: accentColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
