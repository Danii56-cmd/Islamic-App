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
            ? 'Detecting location...'
            : '${currentPosition!.latitude.toStringAsFixed(3)}°, ${currentPosition!.longitude.toStringAsFixed(3)}°');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.my_location_outlined,
          size: 16.sp,
          color: const Color(0xFF8B9491),
        ),
        SizedBox(width: 7.w),
        Flexible(
          child: Text(
            textToShow,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF737D7A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
