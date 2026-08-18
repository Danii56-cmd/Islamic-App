import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/widgets/header_text.dart';

class CalendarHeader extends StatelessWidget {
  final String hijriDate;
  final String location;

  const CalendarHeader({
    super.key,
    required this.hijriDate,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SACRED TIMELINE',
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 5.h),
        const HeaderText(text: 'Islamic Calendar'),
        SizedBox(height: 20.h),
        Row(
          children: [
            _CalendarChip(icon: Icons.calendar_month_outlined, text: hijriDate),

            SizedBox(width: 10.w),

            _CalendarChip(icon: Icons.location_on_outlined, text: location),
          ],
        ),
      ],
    );
  }
}

class _CalendarChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CalendarChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: AppColors.textSecondary),
            SizedBox(width: 7.w),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
