import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class PrayerList extends StatefulWidget {
  const PrayerList({super.key});

  @override
  State<PrayerList> createState() => _PrayerListState();
}

class _PrayerListState extends State<PrayerList> {
  String activePrayer = "Dhuhr";

  final prayers = [
    {"name": "Fajr", "time": "04:52 AM", "icon": Icons.wb_twilight_rounded},
    {"name": "Sunrise", "time": "06:24 AM", "icon": Icons.wb_sunny_outlined},
    {"name": "Dhuhr", "time": "01:15 PM", "icon": Icons.wb_sunny_rounded},
    {"name": "Asr", "time": "04:58 PM", "icon": Icons.wb_sunny_outlined},
    {"name": "Maghrib", "time": "08:04 PM", "icon": Icons.wb_twilight_rounded},
    {"name": "Isha", "time": "09:28 PM", "icon": Icons.nightlight_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(prayers.length, (index) {
        final prayer = prayers[index];

        final String name = prayer["name"] as String;
        final String time = prayer["time"] as String;
        final IconData icon = prayer["icon"] as IconData;

        final bool isActive = name == activePrayer;

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: GestureDetector(
            onTap: () {
              setState(() {
                activePrayer = name;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.04),
                    blurRadius: 6.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Prayer Icon
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryLight
                          : AppColors.scaffoldBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 22.sp,
                        color: isActive ? AppColors.accent : AppColors.textMuted,
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // Prayer Name & Time
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? AppColors.textOnPrimary
                                : AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isActive
                                ? AppColors.textOnPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification Icon
                  Icon(
                    Icons.notifications_active,
                    size: 20.sp,
                    color: isActive ? AppColors.accent : AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
