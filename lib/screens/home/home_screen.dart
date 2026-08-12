import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/appconstants.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/header_text.dart';
import 'package:islamic_app/widgets/upcoming_prayer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const Appbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "ASSALAMU ALAIKUM, AHMAD",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 10.h),
              const HeaderText(text: "A Moment for Reflection"),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                height: 160.h,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 5.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "99",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 115, 92, 0),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "The best among you are those who\nhave the best manners and character.",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "— Sahih Bukhari",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              const UpcomingPrayer(),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisExtent: 100.h,
                  crossAxisSpacing: 20.w,
                  mainAxisSpacing: 15.h,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _featureCard(
                      icon: Icons.explore_outlined,
                      title: "Qibla",
                      onTap: () {},
                    ),
                    _featureCard(
                      icon: Icons.menu_book_rounded,
                      title: "Quran",
                      onTap: () {},
                    ),
                    _featureCard(
                      icon: Icons.history_edu,
                      title: "Hadith",
                      onTap: () {},
                    ),
                    _featureCard(
                      icon: Icons.volunteer_activism_outlined,
                      title: "Duas",
                      onTap: () {},
                    ),
                    _featureCard(
                      icon: Icons.calendar_month_rounded,
                      title: "Islamic Calendar",
                      onTap: () {},
                    ),
                    _featureCard(
                      icon: Icons.bubble_chart,
                      title: "More",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              const JournalContainer(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

class JournalContainer extends StatelessWidget {
  const JournalContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.h,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Appconstants.journalImage, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.prayerCardActiveBg.withValues(alpha: 0.75),
                  ],
                  stops: const [0.25, 1],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WEEKLY JOURNAL",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                    letterSpacing: 1.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "The Architecture of Silence",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "How physical spaces influence our\nspiritual connection and inner peace…",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textOnPrimary.withValues(alpha: 0.7),
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

Widget _featureCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 5.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                color: AppColors.iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(height: 10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
