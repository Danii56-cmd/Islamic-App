import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/providers/notification_provider.dart';
import 'package:islamic_app/providers/prayer_provider.dart';
import 'package:islamic_app/widgets/morescreen_widgets/reusable_card.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationProvider, PrayerProvider>(
      builder: (context, notifProvider, prayerProvider, _) {
        final isNotification = notifProvider.isGlobalEnabled;

        return MyCard(
          backgroundColor: context.textMuted.withValues(alpha: 0.3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: context.accentLight.withValues(alpha: 0.2),
                    child: Icon(
                      isNotification
                          ? Icons.notifications_active
                          : Icons.notifications_off_outlined,
                      color: isNotification
                          ? context.accent
                          : context.textMuted,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Spiritual Notifications",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Prayer times, daily verses, and community updates",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: context.textMuted,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Text(
                    isNotification ? "Enabled" : "Disabled",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Switch(
                    value: isNotification,
                    onChanged: (value) async {
                      await notifProvider.toggleGlobal(
                        value,
                        prayerProvider.timings,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 1),
                            content: Text(
                              value
                                  ? 'Prayer notifications enabled'
                                  : 'Prayer notifications disabled',
                            ),
                          ),
                        );
                      }
                    },
                    activeThumbColor: Colors.white,
                    activeTrackColor: context.primary,
                    inactiveThumbColor: context.textMuted,
                    inactiveTrackColor: Colors.transparent,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
