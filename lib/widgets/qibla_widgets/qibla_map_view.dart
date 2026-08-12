import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/core/appcolors.dart';
import 'package:latlong2/latlong.dart';

class QiblaMapView extends StatelessWidget {
  final MapController mapController;
  final LatLng userLocation;
  final LatLng kaabaLocation;
  final Position? currentPosition;
  final double qiblaDirection;
  final String distanceText;

  const QiblaMapView({
    super.key,
    required this.mapController,
    required this.userLocation,
    required this.kaabaLocation,
    required this.currentPosition,
    required this.qiblaDirection,
    required this.distanceText,
  });

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
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: userLocation,
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
                            points: [userLocation, kaabaLocation],
                            strokeWidth: 4,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: userLocation,
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
                            point: kaabaLocation,
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
                      onTap: () => mapController.move(userLocation, 12),
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
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.iconBackground,
            ),
            child: Icon(Icons.explore, color: AppColors.primary, size: 21.sp),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qibla Direction',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${qiblaDirection.round()}°',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            distanceText,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
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
            value: currentPosition == null
                ? 'Detecting...'
                : '${currentPosition!.latitude.toStringAsFixed(2)}, '
                      '${currentPosition!.longitude.toStringAsFixed(2)}',
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
      height: 75.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 9.sp,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
