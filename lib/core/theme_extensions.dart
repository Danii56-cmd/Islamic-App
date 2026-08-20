import 'package:flutter/material.dart';
import 'appcolors.dart';

extension AppThemeExtension on BuildContext {
  // THEME

  ThemeData get theme => Theme.of(this);
  bool get isDark => theme.brightness == Brightness.dark;

  // BACKGROUNDS

  Color get background => theme.scaffoldBackgroundColor;
  Color get card => theme.cardColor;
  Color get surface => theme.colorScheme.surface;
  Color get iconBackground =>
      isDark ? AppColors.darkIconBackground : AppColors.lightIconBackground;

  // PRIMARY COLORS

  Color get primary => theme.colorScheme.primary;
  Color get primaryDark => AppColors.primaryDark;
  Color get primaryLight => AppColors.primaryLight;

  // ACCENT COLORS

  Color get accent => AppColors.accent;
  Color get accentLight => AppColors.accentLight;

  // TEXT COLORS

  Color get textPrimary =>
      theme.textTheme.bodyLarge?.color ??
      (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
  Color get textSecondary =>
      theme.textTheme.bodyMedium?.color ??
      (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
  Color get textMuted =>
      theme.textTheme.bodySmall?.color ??
      (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted);
  Color get textOnPrimary => theme.colorScheme.onPrimary;

  // PRAYER

  Color get prayerCardActiveBg => AppColors.prayerCardActiveBg;
  Color get prayerCardText => AppColors.prayerCardText;

  // BOTTOM NAVIGATION

  Color get navActive =>
      theme.bottomNavigationBarTheme.selectedItemColor ?? AppColors.navActive;
  Color get navInactive =>
      theme.bottomNavigationBarTheme.unselectedItemColor ??
      AppColors.navInactive;

  // UTILITY

  Color get divider => theme.dividerColor;
  Color get shadow => AppColors.shadow;
  Color get error => theme.colorScheme.error;
  Color get success =>
      isDark ? const Color(0xFF66BB6A) : const Color(0xFF2E7D32);

  // ICONS

  Color get icon => theme.iconTheme.color ?? textPrimary;
  Color get iconSecondary => textSecondary;
}
