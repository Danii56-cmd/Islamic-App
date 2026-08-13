import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

enum AyahTag { highlight, saved, none }

class AyahCard extends StatefulWidget {
  const AyahCard({
    super.key,
    required this.ayahNumber,
    required this.arabicText,
    required this.translation,
    this.tag = AyahTag.none,
    this.isBookmarked = false,
  });

  final int ayahNumber;
  final String arabicText;
  final String translation;
  final AyahTag tag;
  final bool isBookmarked;

  @override
  State<AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<AyahCard> {
  late bool _bookmarked;

  @override
  void initState() {
    super.initState();
    _bookmarked = widget.isBookmarked;
  }

  Color get _tagColor {
    switch (widget.tag) {
      case AyahTag.saved:
        return AppColors.accent;
      case AyahTag.highlight:
        return AppColors.accent;
      case AyahTag.none:
        return Colors.transparent;
    }
  }

  String get _tagLabel {
    switch (widget.tag) {
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
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AyahNumberBadge(number: widget.ayahNumber),
                SizedBox(width: 14.w),
                GestureDetector(
                  onTap: () => setState(() => _bookmarked = !_bookmarked),
                  child: Icon(
                    _bookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    size: 20.sp,
                    color: _bookmarked
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                ),
                SizedBox(width: 14.w),
                // Share icon
                Icon(
                  Icons.share_outlined,
                  size: 20.sp,
                  color: AppColors.textMuted,
                ),
                const Spacer(),
                // Tag label
                if (widget.tag != AyahTag.none)
                  Text(
                    _tagLabel,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: _tagColor,
                      letterSpacing: 1,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 18.h),
            Text(
              widget.arabicText,
              style: TextStyle(
                fontSize: 26.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                height: 2.0,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 16.h),
            Text(
              widget.translation,
              style: TextStyle(
                fontSize: 13.5.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
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
        color: AppColors.textMuted.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
