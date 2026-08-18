import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/appconstants.dart';
import 'package:islamic_app/screens/notifications/notification_screen.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20.w,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.iconBackground,
            backgroundImage: const AssetImage(Appconstants.profile),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "Ahmad Abdullah",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: ((context) => const NotificationScreen())),
            );
          },
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
