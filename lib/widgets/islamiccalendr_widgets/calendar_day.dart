import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/theme_extensions.dart';

class CalendarDay extends StatelessWidget {
  final DateTime date;
  final HijriCalendar hijriDate;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const CalendarDay({
    super.key,
    required this.date,
    required this.hijriDate,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFriday = date.weekday == DateTime.friday;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.symmetric(horizontal: 1.5.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.accent, width: 1.5)
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Date + Hijri date
            Center(
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.noScaling),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? context.textPrimary
                            : isFriday
                            ? context.primary
                            : context.textPrimary,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        height: 0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '${hijriDate.hDay}',
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? context.textPrimary
                            : context.textSecondary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom dot
            if (isSelected)
              Positioned(
                bottom: 3.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: context.textPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
