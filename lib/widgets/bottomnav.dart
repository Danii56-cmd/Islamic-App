import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: context.textMuted.withValues(alpha: 0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_outlined, 'HOME', context),
            _navItem(1, Icons.menu_book_outlined, 'QURAN', context),
            _navItem(2, Icons.access_time_rounded, 'PRAYER', context),
            _navItem(3, Icons.more_horiz_rounded, 'MORE', context),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    int index,
    IconData icon,
    String label,
    BuildContext context,
  ) {
    final isSelected = index == currentIndex;
    final activeColor = context.accent;
    final inactiveColor = context.textMuted;

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22.sp,
            color: isSelected ? activeColor : inactiveColor,
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: 0.8,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
          SizedBox(height: 3.h),
          // Small gold dot indicator underneath the active tab
          Container(
            width: 4.r,
            height: 4.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? activeColor : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
