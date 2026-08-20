import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeChangerProvider>();
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: context.textMuted.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // TOP ROW
          Row(
            children: [
              Icon(
                Icons.dark_mode_outlined,
                color: context.accent,
                size: 28.sp,
              ),
              const Spacer(),
              GestureDetector(
                onTap: themeProvider.toggleTheme,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 86.w,
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? context.primary
                        : context.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(30.r),
                  ),

                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // BACKGROUND ICONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 6.w),
                            child: Icon(
                              Icons.wb_sunny_outlined,
                              size: 16.sp,
                              color: isDarkMode
                                  ? context.textOnPrimary
                                  : context.primary,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Icon(
                              Icons.dark_mode_outlined,
                              size: 16.sp,
                              color: isDarkMode
                                  ? context.textPrimary.withValues(alpha: 0.8)
                                  : context.primary,
                            ),
                          ),
                        ],
                      ),

                      // MOVING CIRCLE
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: isDarkMode
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDarkMode
                                ? Icons.dark_mode_outlined
                                : Icons.wb_sunny_outlined,
                            size: 16.sp,
                            color: context.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // TITLE
          Text(
            'Appearance',

            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          // DESCRIPTION
          Text(
            isDarkMode
                ? 'Dark theme is enabled'
                : 'Switch between light and dark themes',

            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
