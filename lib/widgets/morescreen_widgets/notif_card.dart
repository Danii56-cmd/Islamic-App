import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/widgets/morescreen_widgets/reusable_card.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isNotification = true;
  @override
  Widget build(BuildContext context) {
    return MyCard(
      backgroundColor: AppColors.textMuted.withValues(alpha: 0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.accentLight.withValues(alpha: 0.2),
                child: Icon(
                  Icons.notifications_active,
                  color: AppColors.accent,
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "Prayer times, daily verses, and community updates",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textMuted,
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
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 12.w),
              Switch(
                value: isNotification,
                onChanged: (value) {
                  setState(() {
                    isNotification = value;
                  });
                },
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: AppColors.textMuted,
                inactiveTrackColor: Colors.transparent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
