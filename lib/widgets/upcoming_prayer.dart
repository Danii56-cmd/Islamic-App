import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class UpcomingPrayer extends StatefulWidget {
  const UpcomingPrayer({super.key});

  @override
  State<UpcomingPrayer> createState() => _UpcomingPrayerState();
}

class _UpcomingPrayerState extends State<UpcomingPrayer> {
  @override
  Widget build(BuildContext context) {
    const String activePrayer = "ASR";

    final prayers = [
      {"name": "FAJR", "time": "05:12"},
      {"name": "DHUHR", "time": "12:30"},
      {"name": "ASR", "time": "15:45"},
      {"name": "MAGHRIB", "time": "18:50"},
      {"name": "ISHA", "time": "20:15"},
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP SECTION
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "UPCOMING PRAYER\n",
                          style: TextStyle(
                            color: AppColors.prayerCardText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: "Asr",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Countdown
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "In 01:42:10",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // DIVIDER
            const Divider(thickness: 0.3, height: 1, color: AppColors.divider),

            SizedBox(height: 12.h),

            // PRAYER TIMES
            Row(
              children: prayers.map((prayer) {
                final String name = prayer["name"]!;
                final String time = prayer["time"]!;

                // Check each individual prayer
                final bool isActive = name == activePrayer;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.accentLight
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.accent
                                  : AppColors.prayerCardText,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            time,
                            style: TextStyle(
                              color: isActive
                                  ? AppColors.accent
                                  : AppColors.textOnPrimary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
