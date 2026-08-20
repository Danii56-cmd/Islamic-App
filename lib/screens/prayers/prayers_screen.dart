import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:provider/provider.dart';
import 'package:islamic_app/providers/location_provider.dart';
import 'package:islamic_app/providers/prayer_provider.dart';
import 'package:islamic_app/screens/qibla/qiblafinder_screen.dart';
import 'package:islamic_app/services/prayer_service.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/prayer_list.dart';

class PrayersScreen extends StatelessWidget {
  final bool showQibla;
  final VoidCallback onOpenQibla;
  final VoidCallback onCloseQibla;

  const PrayersScreen({
    super.key,
    required this.showQibla,
    required this.onOpenQibla,
    required this.onCloseQibla,
  });

  void _showCalculationMethodSheet(BuildContext context) {
    final prayerProvider = context.read<PrayerProvider>();
    final locationProvider = context.read<LocationProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: context.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: context.textMuted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Calculation Method",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Select the authority used to calculate daily prayer times.",
                  style: TextStyle(fontSize: 12.sp, color: context.textMuted),
                ),
                SizedBox(height: 14.h),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: CalculationMethod.values.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final method = CalculationMethod.values[index];
                      final isSelected = prayerProvider.method == method;

                      return InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          final lat =
                              locationProvider.location?.latitude ?? 33.6844;
                          final lng =
                              locationProvider.location?.longitude ?? 73.0479;
                          prayerProvider.changeMethod(
                            method,
                            latitude: lat,
                            longitude: lng,
                          );
                        },
                        borderRadius: BorderRadius.circular(14.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.accent.withValues(alpha: 0.15)
                                : context.card,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: isSelected
                                  ? context.accent
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  method.label,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? context.primary
                                        : context.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: context.accent,
                                  size: 20.sp,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showQibla) {
      return QiblaFinderScreen(onBack: onCloseQibla);
    }

    return Scaffold(
      backgroundColor: context.background,
      appBar: const Appbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              const NextPrayerCard(),
              SizedBox(height: 25.h),
              Text(
                "Daily Prayers",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Expanded(
                    child: Consumer<LocationProvider>(
                      builder: (context, locProvider, _) {
                        final locationText =
                            locProvider.location?.label ??
                            (locProvider.status == LocationStatus.loading
                                ? "Locating..."
                                : "Islamabad, Pakistan");

                        return GestureDetector(
                          onTap: () {
                            locProvider.fetchLocation();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14.sp,
                                color: context.textSecondary,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  locationText,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: context.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () => _showCalculationMethodSheet(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Calculation\nSettings",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.tune, color: context.primary, size: 20.sp),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              const PrayerList(),
              SizedBox(height: 10.h),
              // Qibla Direction Card - toggles Qibla finder view
              _infoCard(
                context: context,
                title: "Qibla Direction",
                value: "142° SE",
                icon: Icons.explore_outlined,
                color: const Color.fromARGB(77, 204, 229, 220),
                onTap: onOpenQibla,
              ),
              SizedBox(height: 14.h),
              // Method Card
              Consumer<PrayerProvider>(
                builder: (context, prayerProvider, _) {
                  return _infoCard(
                    context: context,
                    title: "Method",
                    value: prayerProvider.method.label,
                    icon: Icons.info_outline_rounded,
                    color: context.accent.withValues(alpha: 0.3),

                    onTap: () => _showCalculationMethodSheet(context),
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

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: color ?? context.card,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.05),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: context.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Icon(icon, size: 24.sp, color: context.primary),
          ],
        ),
      ),
    );
  }
}

class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerProvider>(
      builder: (context, provider, _) {
        final nextPrayer = provider.nextPrayer;
        final nextName = nextPrayer != null
            ? nextPrayer.name.toUpperCase()
            : "DHUHR";

        String timeStr = "01:30";
        String period = "PM";

        if (nextPrayer != null) {
          final dt = nextPrayer.time;
          final h24 = dt.hour;
          final h12 = h24 == 0 ? 12 : (h24 > 12 ? h24 - 12 : h24);
          final m = dt.minute.toString().padLeft(2, '0');
          timeStr = '${h12.toString().padLeft(2, '0')}:$m';
          period = h24 >= 12 ? 'PM' : 'AM';
        }

        final countdownText = provider.formattedCountdown();

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          decoration: BoxDecoration(
            color: context.primary,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: context.shadow,
                blurRadius: 5.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "NEXT PRAYER: $nextName",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: context.textMuted,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 4.h),
              Text.rich(
                TextSpan(
                  text: timeStr,
                  style: TextStyle(
                    fontSize: 46.sp,
                    fontWeight: FontWeight.w800,
                    color: context.textOnPrimary,
                  ),
                  children: [
                    WidgetSpan(child: SizedBox(width: 5.w)),
                    TextSpan(
                      text: period,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: context.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: context.accentLight,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: context.shadow,
                      blurRadius: 5.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: context.textOnPrimary,
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "In $countdownText",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: context.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
