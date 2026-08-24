import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appconstants.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/screens/favourites/favourites_screen.dart';
import 'package:islamic_app/screens/mainscreen/main_screen.dart';
import 'package:islamic_app/screens/notifications/notification_screen.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20.w,

      title: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: context.iconBackground,
            backgroundImage: const AssetImage(Appconstants.profile),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              "Ahmad Abdullah",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      actions: [
        // FAVOURITES
        IconButton(
          icon: Icon(
            Icons.bookmark_outline_rounded,
            color: context.textPrimary,
            size: 24.sp,
          ),
          tooltip: 'Favourites',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavouritesScreen(),
              ),
            );
          },
        ),

        // SETTINGS
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: context.textPrimary,
            size: 24.sp,
          ),
          onPressed: () {
            openMoreTab?.call();
          },
        ),

        // NOTIFICATIONS
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: context.textPrimary,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
