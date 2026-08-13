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
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: Appbar(),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 30.h),
        child: Column(
          children: [
            ProfileHeader(),
            SizedBox(height: 40.h),
            ThemeCard(),
            SizedBox(height: 15.h),
            LanguageCard(),
            SizedBox(height: 15.h),
            NotificationCard(),
            SizedBox(height: 80.h),
            ReaderCustomizationCard(),
            SizedBox(height: 45.h),
            MoreOptionTile(icon: Icons.help_outline, title: "Help & Support"),
            SizedBox(height: 15.h),
            MoreOptionTile(
              icon: Icons.info_outline,
              title: "About The Sacred Editorial",
            ),
            SizedBox(height: 30.h),
            TextButton.icon(
              onPressed: () {},
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
            SizedBox(height: 45.h),
            Text(
              "VERSION 2.4.0 — CRAFTED WITH INTENTION",
              style: TextStyle(
                fontSize: 8.sp,
                letterSpacing: 2.5,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
