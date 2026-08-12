import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/widgets/appbar.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_compass.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_info_cards.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_location_error.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_location_row.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_map_view.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_toggle.dart';
import 'package:latlong2/latlong.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool isMapSelected = false;
  StreamSubscription<QiblahDirection>? _qiblahSubscription;

  double qiblaDirection = 0;
  double deviceDirection = 0;
  Position? currentPosition;
  bool isLoading = true;
  bool locationError = false;

  final MapController _mapController = MapController();

  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  @override
  void initState() {
    super.initState();
    _initializeQibla();
  }

  Future<void> _initializeQibla() async {
    try {
      final permission = await FlutterQiblah.requestPermissions();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          locationError = true;
          isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      currentPosition = position;

      _qiblahSubscription = FlutterQiblah.qiblahStream.listen((direction) {
        if (!mounted) return;
        setState(() {
          qiblaDirection = direction.qiblah;
          deviceDirection = direction.direction;
          isLoading = false;
        });
      });

      if (mounted) setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        locationError = true;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _qiblahSubscription?.cancel();
    FlutterQiblah().dispose();
    super.dispose();
  }

  double get _distanceKm {
    if (currentPosition == null) return 0;
    return Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          kaabaLatitude,
          kaabaLongitude,
        ) /
        1000;
  }

  String get _distanceText {
    if (currentPosition == null) return '--';
    final d = _distanceKm;
    return d >= 1000
        ? '${(d / 1000).toStringAsFixed(1)}k km'
        : '${d.toStringAsFixed(0)} km';
  }

  LatLng get _userLocation => currentPosition == null
      ? const LatLng(51.5074, -0.1278)
      : LatLng(currentPosition!.latitude, currentPosition!.longitude);

  LatLng get _kaabaLocation => const LatLng(kaabaLatitude, kaabaLongitude);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: Appbar(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 18.h),
            QiblaToggle(
              isMapSelected: isMapSelected,
              onChanged: (v) => setState(() => isMapSelected = v),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isMapSelected ? _mapView() : _compassView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compassView() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (locationError) return QiblaLocationError(onRetry: _initializeQibla);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 25.h),
          QiblaCompass(
            qiblaDirection: qiblaDirection,
            deviceDirection: deviceDirection,
          ),
          SizedBox(height: 55.h),
          Text(
            'QIBLA DIRECTION',
            style: TextStyle(
              fontSize: 12.sp,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
              color: const Color(0xff59615F),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${qiblaDirection.round()}',
                style: TextStyle(
                  fontSize: 47.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff004D40),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '°',
                style: TextStyle(
                  fontSize: 27.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xffA88300),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          QiblaInfoCards(distanceText: _distanceText),
          SizedBox(height: 28.h),
          QiblaLocationRow(currentPosition: currentPosition),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _mapView() {
    return QiblaMapView(
      mapController: _mapController,
      userLocation: _userLocation,
      kaabaLocation: _kaabaLocation,
      currentPosition: currentPosition,
      qiblaDirection: qiblaDirection,
      distanceText: _distanceText,
    );
  }
}
