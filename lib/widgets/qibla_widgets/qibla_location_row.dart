import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class QiblaLocationRow extends StatelessWidget {
  final Position? currentPosition;
  final String? locationName;

  const QiblaLocationRow({
    super.key,
    required this.currentPosition,
    this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    final textToShow = locationName ??
        (currentPosition == null
            ? 'London, United Kingdom'
            : '${currentPosition!.latitude.toStringAsFixed(2)}°, ${currentPosition!.longitude.toStringAsFixed(2)}°');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.my_location_outlined,
          size: 16.sp,
          color: const Color(0xFF8B9491),
        ),
        SizedBox(width: 7.w),
        Text(
          textToShow,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF737D7A),
          ),
        ),
      ],
    );
  }
}
