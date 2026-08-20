import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/providers/fontsize_provider.dart';
import 'package:provider/provider.dart';
import 'package:islamic_app/widgets/morescreen_widgets/reusable_card.dart';

class ReaderCustomizationCard extends StatelessWidget {
  const ReaderCustomizationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final fontProvider = context.watch<FontSizeProvider>();
    final currentSize = fontProvider.fontSize;

    return MyCard(
      backgroundColor: context.textMuted.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.format_size, color: context.primaryDark, size: 22.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "Reader Customization",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ReaderFontSize.values.map((size) {
              final isActive = size == currentSize;
              return Text(
                size.label,
                style: TextStyle(
                  fontSize: 11.sp,
                  letterSpacing: 1,
                  color: isActive ? context.primary : context.textMuted,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              );
            }).toList(),
          ),

          Slider(
            value: currentSize.sliderValue,
            min: 0,
            max: 2,
            divisions: 2,
            activeColor: context.primary,
            inactiveColor: context.textMuted.withValues(alpha: 0.2),
            onChanged: (value) {
              context.read<FontSizeProvider>().setFontSize(value);
            },
          ),
          // Internal Container — live preview
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: context.textMuted.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(8.r),
              border: Border(
                left: BorderSide(color: context.accent, width: 3.w),
              ),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 16.sp * fontProvider.scale,
                color: context.textSecondary,
                height: 1.5,
              ),
              child: const Text(
                '"The heart finds rest in the remembrance of the Divine."',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              "— SAMPLE TEXT PREVIEW",
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: context.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
