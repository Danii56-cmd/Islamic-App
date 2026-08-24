import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appconstants.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/screens/calendar/islamiccalendar_screen.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/header_text.dart';
import 'package:islamic_app/widgets/upcoming_prayer.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int index)? onNavigateToTab;
  final bool showCalendar;
  final VoidCallback onOpenCalendar;
  final VoidCallback onCloseCalendar;
  final VoidCallback? onOpenQibla;
  final VoidCallback? onOpenDuas;
  final VoidCallback? onOpenMore;

  const HomeScreen({
    super.key,
    this.onNavigateToTab,
    this.showCalendar = false,
    required this.onOpenCalendar,
    required this.onCloseCalendar,
    this.onOpenQibla,
    this.onOpenDuas,
    this.onOpenMore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: const Appbar(),
      body: showCalendar
          ? IslamicCalendarScreen(onBack: onCloseCalendar)
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "ASSALAMU ALAIKUM, AHMAD",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: context.textMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const HeaderText(text: "A Moment for Reflection"),
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.card,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: context.shadow,
                            blurRadius: 5.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                              "The best among you are those who have the best manners and character.",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: context.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "— Sahih Bukhari",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: context.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const UpcomingPrayer(),
                    SizedBox(height: 25.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 14.h,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _featureCard(
                            context: context,
                            icon: Icons.explore_outlined,
                            title: "Qibla",
                            onTap: () {
                              onOpenQibla?.call();
                            },
                          ),
                          _featureCard(
                            context: context,
                            icon: Icons.menu_book_rounded,
                            title: "Quran",
                            onTap: () {
                              onNavigateToTab?.call(1);
                            },
                          ),
                          _featureCard(
                            context: context,
                            icon: Icons.history_edu,
                            title: "Hadith",
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Hadith feature coming soon!"),
                                ),
                              );
                            },
                          ),
                          _featureCard(
                            context: context,
                            icon: Icons.volunteer_activism_outlined,
                            title: "Duas",
                            onTap: () {
                              onOpenDuas?.call();
                            },
                          ),
                          _featureCard(
                            context: context,
                            icon: Icons.calendar_month_rounded,
                            title: "Islamic Calendar",
                            onTap: () {
                              onOpenCalendar();
                            },
                          ),
                          _featureCard(
                            context: context,
                            icon: Icons.bubble_chart,
                            title: "More",
                            onTap: () {
                              onOpenMore?.call();
                            },
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
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: const DecorationImage(
          image: AssetImage(Appconstants.mosqueImage),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.15),
              context.prayerCardActiveBg.withValues(alpha: 0.85),
            ],
            stops: const [0.1, 1.0],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "WEEKLY JOURNAL",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: context.accent,
                letterSpacing: 1.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "The Architecture of Silence",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "How physical spaces influence our spiritual connection and inner peace…",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: context.textPrimary.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _featureCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 5.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: context.iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.primary, size: 20.sp),
            ),
            SizedBox(height: 6.h),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: context.primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

extension on BuildContext {
  Color? get primaryText => null;
}
