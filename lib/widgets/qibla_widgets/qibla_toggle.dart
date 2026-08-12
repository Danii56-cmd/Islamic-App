import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';

class QiblaToggle extends StatelessWidget {
  final bool isMapSelected;
  final ValueChanged<bool> onChanged;

  const QiblaToggle({
    super.key,
    required this.isMapSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235.w,
      height: 52.h,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: const Color(0xffF2F3F2),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          _segment(
            'Compass',
            selected: !isMapSelected,
            onTap: () => onChanged(false),
          ),
          _segment(
            'Map',
            selected: isMapSelected,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }

  Widget _segment(
    String text, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
