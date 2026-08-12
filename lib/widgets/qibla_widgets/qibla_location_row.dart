import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/appcolors.dart';

class QiblaLocationRow extends StatelessWidget {
  final Position? currentPosition;

  const QiblaLocationRow({super.key, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.my_location_outlined,
          size: 16.sp,
          color: AppColors.textMuted,
        ),
        SizedBox(width: 7.w),
        Text(
          currentPosition == null
              ? 'Detecting location...'
              : '${currentPosition!.latitude.toStringAsFixed(4)}, '
                    '${currentPosition!.longitude.toStringAsFixed(4)}',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
