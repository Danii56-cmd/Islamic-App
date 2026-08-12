import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      width: 220.w,
      height: 46.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F3),
        borderRadius: BorderRadius.circular(28.r),
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
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? const Color(0xFF003831)
                    : const Color(0xFF677370),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
