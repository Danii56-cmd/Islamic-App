import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/screens/qibla/qiblafinder_screen.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/prayer_list.dart';

class PrayersScreen extends StatelessWidget {
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: Appbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              NextPrayerCard(),
              SizedBox(height: 30.h),
              Text(
                "Daily Prayers",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14.sp),
                  Text(
                    "Islamabad, Pakistan",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Calculation\nSettings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Icon(Icons.tune, color: AppColors.primary),
                ],
              ),
              SizedBox(height: 20.h),
              PrayerList(),
              SizedBox(height: 20.h),
              // Qibla Direction
              _infoCard(
                title: "Qibla Direction",
                value: "147° SE",
                icon: Icons.explore_outlined,
                color: const Color.fromARGB(77, 204, 229, 220),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QiblaScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 15.h),
              // Method
              _infoCard(
                title: "Method",
                value: "Turkey (Diyanet)",
                icon: Icons.info_outline_rounded,
                color: AppColors.accent.withValues(alpha: 0.3),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Method tapped")),
                  );
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _infoCard({
  required String title,
  required String value,
  required IconData icon,
  required VoidCallback onTap,
  Color? color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 105.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, size: 23.sp, color: AppColors.primary),
        ],
      ),
    ),
  );
}

class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 05.r,
            offset: Offset(0, 02.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "NEXT PRAYER: DHUHR",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              letterSpacing: 1.0,
            ),
          ),
          Text.rich(
            TextSpan(
              text: "01:30",
              style: TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.w800,
                color: AppColors.textOnPrimary,
              ),
              children: [
                WidgetSpan(child: SizedBox(width: 5.w)),
                TextSpan(
                  text: "PM",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 05.h),
          Container(
            height: 30.h,
            width: 120.w,
            decoration: BoxDecoration(
              color: AppColors.accentLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 05.r,
                  offset: Offset(0, 02.h),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: AppColors.accent,
                  size: 16,
                ),
                SizedBox(width: 5.w),
                Text(
                  "In 45 minutes",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
