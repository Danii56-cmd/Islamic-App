import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:islamic_app/providers/qibla_provider.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/custom_pop_scope.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_compass.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_info_cards.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_location_error.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_location_row.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_map_view.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_toggle.dart';
import 'package:provider/provider.dart';

class QiblaFinderScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const QiblaFinderScreen({super.key, this.onBack});

  @override
  State<QiblaFinderScreen> createState() => _QiblaFinderScreenState();
}

class _QiblaFinderScreenState extends State<QiblaFinderScreen> {
  bool isMapSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<QiblaProvider>().initIfNeeded();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final qibla = context.watch<QiblaProvider>();

    return CustomPopScope(
      isRoot: false,
      onBackPressed: () {
        if (widget.onBack != null) {
          widget.onBack!();
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: context.background,
        appBar: const Appbar(),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 6.h),
              // Top Back button + View Toggle row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    if (widget.onBack != null) ...[
                      InkWell(
                        onTap: widget.onBack,
                        borderRadius: BorderRadius.circular(20.r),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF2F4F3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16.sp,
                            color: context.icon,
                          ),
                        ),
                      ),
                    ],
                    Expanded(
                      child: Center(
                        child: QiblaToggle(
                          isMapSelected: isMapSelected,
                          onChanged: (v) => setState(() => isMapSelected = v),
                        ),
                      ),
                    ),
                    if (widget.onBack != null) SizedBox(width: 36.w),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isMapSelected
                      ? QiblaMapView(
                          key: const ValueKey('map'),
                          userLocation: qibla.userLatLng,
                          kaabaLocation: qibla.kaabaLatLng,
                          currentPosition: qibla.currentPosition,
                          qiblaDirection: qibla.qiblaBearing,
                          distanceText: qibla.distanceText,
                        )
                      : Container(
                          key: const ValueKey('compass'),
                          child: _buildCompassView(context, qibla),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompassView(BuildContext context, QiblaProvider qibla) {
    if (qibla.locationStatus == QiblaLocationStatus.loading &&
        qibla.currentPosition == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF004D40)),
            SizedBox(height: 14.h),
            Text(
              'Finding accurate GPS location...',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF5E6966),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (qibla.locationStatus != QiblaLocationStatus.ready &&
        qibla.currentPosition == null) {
      return QiblaLocationError(
        status: qibla.locationStatus,
        errorMessage: qibla.errorMessage,
        onRetry: () => qibla.checkAndFetchLocation(requestIfNeeded: true),
        onOpenSettings: qibla.locationStatus == QiblaLocationStatus.serviceDisabled
            ? qibla.openLocationSettings
            : qibla.openAppSettings,
      );
    }

    if (qibla.sensorStatus == QiblaSensorStatus.unavailable) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sensors_off,
                size: 48.sp,
                color: const Color(0xFF9CA3AF),
              ),
              SizedBox(height: 16.h),
              Text(
                'No compass sensor (magnetometer) detected on this device.\nPlease switch to Map View to find Qibla.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF5E6966),
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => setState(() => isMapSelected = true),
                icon: const Icon(Icons.map_outlined),
                label: const Text('Open Map View'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D40),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          children: [
            // Compass with dynamic heading & Qibla bearing
            QiblaCompass(
              qiblaBearing: qibla.qiblaBearing,
              deviceHeading: qibla.deviceHeading,
              isAligned: qibla.isAligned,
              needsCalibration: qibla.needsCalibration,
            ),
            SizedBox(height: 14.h),
            Text(
              'QIBLA DIRECTION',
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5E6966),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${qibla.qiblaBearing.round()}',
                  style: TextStyle(
                    fontSize: 46.sp,
                    fontWeight: FontWeight.w800,
                    color: qibla.isAligned
                        ? const Color(0xFF00796B)
                        : const Color(0xFF003831),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '°',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC5A038),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            QiblaInfoCards(
              distanceText: qibla.distanceText,
              deviceHeading: qibla.deviceHeading,
              isAligned: qibla.isAligned,
            ),
            SizedBox(height: 14.h),
            QiblaLocationRow(
              currentPosition: qibla.currentPosition,
              locationName: qibla.locationName,
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
