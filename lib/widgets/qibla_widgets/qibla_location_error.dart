import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/providers/qibla_provider.dart';

class QiblaLocationError extends StatelessWidget {
  final QiblaLocationStatus status;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback? onOpenSettings;

  const QiblaLocationError({
    super.key,
    required this.status,
    this.errorMessage,
    required this.onRetry,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final bool isServiceDisabled =
        status == QiblaLocationStatus.serviceDisabled;
    final bool isPermanentlyDenied =
        status == QiblaLocationStatus.permissionDeniedForever;

    final String title = isServiceDisabled
        ? 'Location is Turned Off'
        : 'Location Permission Required';

    final String description = isServiceDisabled
        ? 'Please turn on location in settings to find the Qibla direction.'
        : 'Please allow location access to calculate the Qibla direction.';

    final String buttonText = isServiceDisabled
        ? 'Open Location Settings'
        : (isPermanentlyDenied ? 'Open Settings' : 'Enable Location');

    final VoidCallback action = (isServiceDisabled || isPermanentlyDenied)
        ? (onOpenSettings ?? onRetry)
        : onRetry;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isServiceDisabled
                  ? Icons.location_off_rounded
                  : Icons.my_location_rounded,
              size: 46.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: context.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: action,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 11.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
