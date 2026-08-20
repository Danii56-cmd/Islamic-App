import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_compass.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_info_cards.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_location_error.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_location_row.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_map_view.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_toggle.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:islamic_app/providers/location_provider.dart';

class QiblaFinderScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const QiblaFinderScreen({super.key, this.onBack});

  @override
  State<QiblaFinderScreen> createState() => _QiblaFinderScreenState();
}

class _QiblaFinderScreenState extends State<QiblaFinderScreen> {
  bool isMapSelected = false;

  // Fixed bearing from user's GPS to Kaaba (degrees from North, clockwise)
  double qiblaBearing = 142.0;

  Position? currentPosition;
  bool isLoading = true;
  bool locationError = false;
  bool noSensor = false;

  static const double kaabaLat = 21.422487;
  static const double kaabaLng = 39.826206;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // 1. Check sensor
    if (FlutterCompass.events == null) {
      if (mounted)
        setState(() {
          noSensor = true;
          isLoading = false;
        });
      return;
    }

    // 2. Location permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (mounted) setState(() => isLoading = false);

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return; // Use default bearing
    }

    // 3. Get GPS fix
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 6));

      if (!mounted) return;
      setState(() {
        currentPosition = pos;
        qiblaBearing = _calcBearing(pos.latitude, pos.longitude);
      });
    } catch (_) {
      // Keep default bearing
    }
  }

  /// Great-circle bearing from (lat, lng) to Kaaba.
  double _calcBearing(double lat, double lng) {
    final lat1 = lat * math.pi / 180;
    final lat2 = kaabaLat * math.pi / 180;
    final dLng = (kaabaLng - lng) * math.pi / 180;
    final y = math.sin(dLng) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    return ((math.atan2(y, x) * 180 / math.pi) + 360) % 360;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Distance

  double get _distanceKm {
    final lat = currentPosition?.latitude ?? 51.5074;
    final lng = currentPosition?.longitude ?? -0.1278;

    // Haversine formula for accurate great-circle distance
    const R = 6371.0; // Earth radius in km
    final lat1 = lat * math.pi / 180;
    final lat2 = kaabaLat * math.pi / 180;
    final dLat = (kaabaLat - lat) * math.pi / 180;
    final dLng = (kaabaLng - lng) * math.pi / 180;
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  String get _distanceText {
    final d = _distanceKm;
    if (d >= 1000) {
      // Format like "4,281 km"
      final rounded = d.round();
      final t = rounded ~/ 1000;
      final r = rounded % 1000;
      return '$t,${r.toString().padLeft(3, '0')} km';
    }
    return '${d.round()} km';
  }

  LatLng get _userLatLng => currentPosition == null
      ? const LatLng(51.5074, -0.1278)
      : LatLng(currentPosition!.latitude, currentPosition!.longitude);

  LatLng get _kaabaLatLng => const LatLng(kaabaLat, kaabaLng);

  // Build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFA),
      appBar: const Appbar(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 6.h),
            // Back button + toggle row
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
                          color: const Color(0xFF003831),
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
                        userLocation: _userLatLng,
                        kaabaLocation: _kaabaLatLng,
                        currentPosition: currentPosition,
                        qiblaDirection: qiblaBearing,
                        distanceText: _distanceText,
                      )
                    : Container(
                        key: const ValueKey('compass'),
                        child: _compassBody(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compassBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF004D40)),
      );
    }

    if (noSensor) {
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
                'No compass sensor detected on this device.\nPlease use the Map view instead.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF5E6966),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (locationError) {
      return QiblaLocationError(onRetry: _init);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          children: [
            // Compass — reads sensor internally via StreamBuilder
            QiblaCompass(qiblaBearing: qiblaBearing),
            SizedBox(height: 16.h),
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
                  '${qiblaBearing.round()}',
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF003831),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '°',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC5A038),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            QiblaInfoCards(distanceText: _distanceText),
            SizedBox(height: 16.h),
            QiblaLocationRow(
              currentPosition: currentPosition,
              locationName: context.watch<LocationProvider>().location?.label ??
                  (currentPosition == null
                      ? 'London, United Kingdom'
                      : null),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
