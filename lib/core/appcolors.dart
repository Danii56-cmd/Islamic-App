import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primary = Color.fromARGB(
    255,
    0,
    77,
    64,
  ); // Deep teal (prayer card, headings)
  static const Color primaryDark = Color(0xFF0A2E2F); // Darker teal shade
  static const Color primaryLight = Color(
    0xFF1A5556,
  ); // Lighter teal for gradients

  // Accent colors
  static const Color accent = Color(
    0xFFD4A24E,
  ); // Gold (quote mark, "In 01:42:10" badge)
  static const Color accentLight = Color.fromARGB(
    110,
    204,
    167,
    48,
  ); // Lighter gold for highlights

  // Background colors
  static const Color scaffoldBackground = Color.fromARGB(
    255,
    249,
    249,
    249,
  ); // Off-white app background
  static const Color cardBackground = Color(
    0xFFFFFFFF,
  ); // White cards (quote, feature cards)
  static const Color iconBackground = Color.fromARGB(
    250,
    204,
    220,
    225,
  ); // Soft mint (Qibla/Quran/Hadith icons)

  // Text colors
  static const Color textPrimary = Color.fromARGB(255, 0, 52, 43);
  static const Color textSecondary = Color(0xFF6B7280); // Subtext, labels
  static const Color textOnPrimary = Color(
    0xFFFFFFFF,
  ); // Text on teal background
  static const Color textMuted = Color(
    0xFF9CA3AF,
  ); // "ASSALAMU ALAIKUM" small caps label

  // Prayer time card specific
  static const Color prayerCardActiveBg = Color(
    0xFF2C5F52,
  ); // Highlighted "Asr" active box
  static const Color prayerCardText = Color(
    0xFFB8CFC7,
  ); // Faded prayer labels (Fajr, Dhuhr...)

  // Bottom nav
  static const Color navActive = Color(0xFFD4A24E); // Gold active tab (Home)
  static const Color navInactive = Color(0xFF9CA3AF); // Inactive tabs

  // Status/utility
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x1A000000);
}
