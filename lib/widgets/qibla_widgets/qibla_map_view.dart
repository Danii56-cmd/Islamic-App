import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:islamic_app/core/theme_extensions.dart';
import 'package:latlong2/latlong.dart';

class QiblaMapView extends StatefulWidget {
  final LatLng userLocation;
  final LatLng kaabaLocation;
  final Position? currentPosition;
  final double qiblaDirection;
  final String distanceText;

  const QiblaMapView({
    super.key,
    required this.userLocation,
    required this.kaabaLocation,
    required this.currentPosition,
    required this.qiblaDirection,
    required this.distanceText,
  });

  @override
  State<QiblaMapView> createState() => _QiblaMapViewState();
}

class _QiblaMapViewState extends State<QiblaMapView> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(covariant QiblaMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userLocation != widget.userLocation) {
      try {
        _mapController.move(widget.userLocation, _mapController.camera.zoom);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: widget.userLocation,
                      initialZoom: 5.5,
                      minZoom: 2,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        maxZoom: 19,
                        userAgentPackageName: 'com.example.islamic_app',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [widget.userLocation, widget.kaabaLocation],
                            strokeWidth: 4,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: widget.userLocation,
                            width: 50,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Marker(
                            point: widget.kaabaLocation,
                            width: 55,
                            height: 55,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accent,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.mosque,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 15.h,
                    left: 15.w,
                    right: 15.w,
                    child: _mapInfo(),
                  ),
                  Positioned(
                    right: 15.w,
                    bottom: 15.h,
                    child: GestureDetector(
                      onTap: () => _mapController.move(widget.userLocation, 12),
                      child: Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.my_location,
                          color: AppColors.primary,
                          size: 23.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          _bottomInfo(),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _mapInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.iconBackground,
            ),
            child: Icon(Icons.explore, color: context.primary, size: 21.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Qibla Direction',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: context.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${widget.qiblaDirection.round()}°',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              widget.distanceText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: context.primary,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomInfo() {
    return Row(
      children: [
        Expanded(
          child: _smallCard(
            title: 'YOUR LOCATION',
            value: widget.currentPosition == null
                ? 'Detecting...'
                : '${widget.currentPosition!.latitude.toStringAsFixed(2)}, '
                      '${widget.currentPosition!.longitude.toStringAsFixed(2)}',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _smallCard(title: 'KAABA', value: 'Makkah, Saudi Arabia'),
        ),
      ],
    );
  }

  Widget _smallCard({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 9.sp,
              letterSpacing: 1,
              color: context.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
