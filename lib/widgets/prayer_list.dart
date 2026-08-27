import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/providers/notification_provider.dart';
import 'package:islamic_app/providers/prayer_provider.dart';
import 'package:provider/provider.dart';

class PrayerList extends StatelessWidget {
  const PrayerList({super.key});

  IconData _iconForPrayer(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight_rounded;
      case 'sunrise':
        return Icons.wb_sunny_outlined;
      case 'dhuhr':
        return Icons.wb_sunny_rounded;
      case 'asr':
        return Icons.wb_sunny_outlined;
      case 'maghrib':
        return Icons.wb_twilight_rounded;
      case 'isha':
        return Icons.nightlight_outlined;
      default:
        return Icons.access_time_rounded;
    }
  }

  String _format12(DateTime dt) {
    final h24 = dt.hour;
    final hour12 = h24 == 0 ? 12 : (h24 > 12 ? h24 - 12 : h24);
    final m = dt.minute.toString().padLeft(2, '0');
    final period = h24 >= 12 ? 'PM' : 'AM';
    return '${hour12.toString().padLeft(2, '0')}:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PrayerProvider, NotificationProvider>(
      builder: (context, provider, notifProvider, _) {
        final timings = provider.timings;
        final activePrayer = provider.activePrayerName;

        final List<Map<String, dynamic>> prayers = timings != null
            ? timings.entries.map((e) {
                return {
                  "name": e.name,
                  "time": _format12(e.time),
                  "icon": _iconForPrayer(e.name),
                };
              }).toList()
            : [
                {
                  "name": "Fajr",
                  "time": "04:52 AM",
                  "icon": Icons.wb_twilight_rounded,
                },
                {
                  "name": "Sunrise",
                  "time": "06:24 AM",
                  "icon": Icons.wb_sunny_outlined,
                },
                {
                  "name": "Dhuhr",
                  "time": "01:15 PM",
                  "icon": Icons.wb_sunny_rounded,
                },
                {
                  "name": "Asr",
                  "time": "04:58 PM",
                  "icon": Icons.wb_sunny_outlined,
                },
                {
                  "name": "Maghrib",
                  "time": "08:04 PM",
                  "icon": Icons.wb_twilight_rounded,
                },
                {
                  "name": "Isha",
                  "time": "09:28 PM",
                  "icon": Icons.nightlight_outlined,
                },
              ];

        return Column(
          children: List.generate(prayers.length, (index) {
            final prayer = prayers[index];
            final String name = prayer["name"] as String;
            final String time = prayer["time"] as String;
            final IconData icon = prayer["icon"] as IconData;

            final bool isActive =
                name.toLowerCase() ==
                (activePrayer.isEmpty ? "dhuhr" : activePrayer.toLowerCase());
            final bool isPrayerEnabled = notifProvider.isPrayerEnabled(name);
            final bool isNotifActive = notifProvider.isPrayerActive(name);

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isActive ? context.primary : context.card,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: context.shadow.withValues(alpha: 0.04),
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
                            ? context.primaryLight
                            : context.background,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 22.sp,
                          color: isActive ? context.accent : context.textMuted,
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
                                  ? context.textOnPrimary
                                  : context.primary,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isActive
                                  ? context.textOnPrimary
                                  : context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notification Icon Toggle
                    GestureDetector(
                      onTap: () async {
                        final nextState = !isPrayerEnabled;
                        await notifProvider.togglePrayer(
                          name,
                          nextState,
                          provider.timings,
                        );

                        if (context.mounted) {
                          String message;
                          if (!nextState) {
                            message = 'Notifications muted for $name';
                          } else if (!notifProvider.isGlobalEnabled) {
                            message =
                                '$name enabled (Turn on notifications in More screen to receive alerts)';
                          } else {
                            message = 'Azan notification set for $name';
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(message),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Icon(
                          isNotifActive
                              ? Icons.notifications_active
                              : (isPrayerEnabled
                                    ? Icons.notifications_none_rounded
                                    : Icons.notifications_off_outlined),
                          size: 20.sp,
                          color: isActive
                              ? context.accent
                              : (isNotifActive
                                    ? context.primary
                                    : context.textMuted),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
