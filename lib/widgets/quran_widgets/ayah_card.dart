import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';

enum AyahTag { highlight, saved, none }

class AyahCard extends StatelessWidget {
  const AyahCard({
    super.key,
    required this.ayahNumber,
    required this.arabicText,
    required this.translation,
    this.tag = AyahTag.none,
    this.isBookmarked = false,
    this.onBookmarkTap,
    this.onShareTap,
  });

  final int ayahNumber;
  final String arabicText;
  final String translation;
  final AyahTag tag;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onShareTap;

  Color _tagColor(BuildContext context) {
    switch (tag) {
      case AyahTag.saved:
        return context.accent;
      case AyahTag.highlight:
        return context.accent;
      case AyahTag.none:
        return Colors.transparent;
    }
  }

  String get _tagLabel {
    switch (tag) {
      case AyahTag.saved:
        return 'SAVED';
      case AyahTag.highlight:
        return 'HIGHLIGHT';
      case AyahTag.none:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TOP ROW
            Row(
              children: [
                _AyahNumberBadge(number: ayahNumber),
                SizedBox(width: 14.w),

                // BOOKMARK
                GestureDetector(
                  onTap: onBookmarkTap,
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    size: 20.sp,
                    color: isBookmarked ? context.primary : context.textMuted,
                  ),
                ),
                SizedBox(width: 14.w),

                // SHARE
                GestureDetector(
                  onTap: onShareTap,
                  child: Icon(
                    Icons.share_outlined,
                    size: 20.sp,
                    color: context.textMuted,
                  ),
                ),
                const Spacer(),
                // TAG
                if (tag != AyahTag.none)
                  Text(
                    _tagLabel,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: _tagColor(context),
                      letterSpacing: 1,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 18.h),

            // ARABIC
            Text(
              arabicText,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 26.sp,
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                height: 2,
              ),
            ),
            SizedBox(height: 16.h),

            // TRANSLATION
            Text(
              translation,
              style: TextStyle(
                fontSize: 13.5.sp,
                color: context.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahNumberBadge extends StatelessWidget {
  const _AyahNumberBadge({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.textMuted.withValues(alpha: 0.10),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: context.textPrimary,
        ),
      ),
    );
  }
}
