import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/morescreen_widgets/help_about.dart';
import 'package:islamic_app/widgets/morescreen_widgets/lang_card.dart';
import 'package:islamic_app/widgets/morescreen_widgets/notif_card.dart';
import 'package:islamic_app/widgets/morescreen_widgets/profile_header.dart';
import 'package:islamic_app/widgets/morescreen_widgets/read_custom.dart';
import 'package:islamic_app/widgets/morescreen_widgets/theme_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({
    super.key,
    required GlobalKey<NavigatorState> navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: Appbar(),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ProfileHeader(),
            SizedBox(height: 30.h),
            const ThemeCard(),
            SizedBox(height: 14.h),
            const LanguageCard(),
            SizedBox(height: 14.h),
            const NotificationCard(),
            SizedBox(height: 20.h),
            const ReaderCustomizationCard(),
            SizedBox(height: 20.h),
            MoreOptionTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "This feature will be available in the next update.",
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            MoreOptionTile(
              icon: Icons.info_outline,
              title: "About The Sacred Editorial",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "This feature will be available in the next update.",
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Sign Out functionality not implemented."),
                  ),
                );
              },
              icon: Icon(Icons.logout, color: Colors.red, size: 20.sp),
              label: Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "VERSION 2.4.0 — CRAFTED WITH INTENTION",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.sp,
                letterSpacing: 2.0,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
