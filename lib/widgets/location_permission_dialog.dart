import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/providers/location_provider.dart';
import 'package:islamic_app/providers/qibla_provider.dart';
import 'package:provider/provider.dart';

class LocationPermissionDialog extends StatefulWidget {
  final VoidCallback? onGranted;
  final VoidCallback? onDenied;

  const LocationPermissionDialog({
    super.key,
    this.onGranted,
    this.onDenied,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onGranted,
    VoidCallback? onDenied,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => LocationPermissionDialog(
        onGranted: onGranted,
        onDenied: onDenied,
      ),
    );
  }

  @override
  State<LocationPermissionDialog> createState() =>
      _LocationPermissionDialogState();
}

class _LocationPermissionDialogState extends State<LocationPermissionDialog> {
  bool isPrecise = true;

  Future<void> _handleAllow() async {
    Navigator.of(context).pop();
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        await Geolocator.openLocationSettings();
        widget.onDenied?.call();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        widget.onDenied?.call();
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        if (mounted) {
          context.read<LocationProvider>().fetchLocation();
          context.read<QiblaProvider>().checkAndFetchLocation();
        }
        widget.onGranted?.call();
      } else {
        widget.onDenied?.call();
      }
    } catch (_) {
      widget.onDenied?.call();
    }
  }

  void _handleDeny() {
    Navigator.of(context).pop();
    widget.onDenied?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top location icon
            Icon(
              Icons.location_on_outlined,
              color: const Color(0xFF1A73E8),
              size: 32.sp,
            ),
            SizedBox(height: 12.h),

            // Title
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF1F2937),
                  height: 1.35,
                ),
                children: [
                  const TextSpan(text: 'Allow '),
                  TextSpan(
                    text: 'Islamic App',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const TextSpan(
                    text: " to access this device's location?",
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.h),

            // Visual Circles: Precise vs Approximate
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Precise Option
                GestureDetector(
                  onTap: () => setState(() => isPrecise = true),
                  child: Column(
                    children: [
                      Container(
                        width: 95.w,
                        height: 95.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE8F0FE),
                          border: Border.all(
                            color: isPrecise
                                ? const Color(0xFF1A73E8)
                                : Colors.transparent,
                            width: isPrecise ? 2.5 : 1,
                          ),
                        ),
                        child: CustomPaint(
                          painter: _PreciseMapPainter(isSelected: isPrecise),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Precise',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight:
                              isPrecise ? FontWeight.w700 : FontWeight.w500,
                          color: isPrecise
                              ? const Color(0xFF1A73E8)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),

                // Approximate Option
                GestureDetector(
                  onTap: () => setState(() => isPrecise = false),
                  child: Column(
                    children: [
                      Container(
                        width: 95.w,
                        height: 95.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF9FAFB),
                          border: Border.all(
                            color: !isPrecise
                                ? const Color(0xFF1A73E8)
                                : Colors.transparent,
                            width: !isPrecise ? 2.5 : 1,
                          ),
                        ),
                        child: CustomPaint(
                          painter:
                              _ApproximateMapPainter(isSelected: !isPrecise),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Approximate',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight:
                              !isPrecise ? FontWeight.w700 : FontWeight.w500,
                          color: !isPrecise
                              ? const Color(0xFF1A73E8)
                              : const Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Action Buttons with dividers
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Column(
                children: [
                  _buildActionButton(
                    title: 'While using the app',
                    onTap: _handleAllow,
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildActionButton(
                    title: 'Only this time',
                    onTap: _handleAllow,
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildActionButton(
                    title: 'Deny',
                    onTap: _handleDeny,
                    color: const Color(0xFF1A73E8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required VoidCallback onTap,
    Color color = const Color(0xFF1A73E8),
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _PreciseMapPainter extends CustomPainter {
  final bool isSelected;
  const _PreciseMapPainter({required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final linePaint = Paint()
      ..color = const Color(0xFFCFD8DC)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Background road lines
    canvas.drawLine(Offset(w * 0.2, 0), Offset(w * 0.8, h), linePaint);
    canvas.drawLine(Offset(0, h * 0.3), Offset(w, h * 0.7), linePaint);
    canvas.drawLine(Offset(w * 0.7, 0), Offset(w * 0.3, h), linePaint);
    canvas.drawLine(Offset(0, h * 0.7), Offset(w, h * 0.2), linePaint);

    // Green soft area
    final greenPaint = Paint()
      ..color = const Color(0xFFC8E6C9).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.55, h * 0.15, w * 0.28, h * 0.22),
        const Radius.circular(6),
      ),
      greenPaint,
    );

    // Small map dots
    final dotPaint = Paint()
      ..color = const Color(0xFF1A73E8).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.28, h * 0.55), 2.5, dotPaint);
    canvas.drawCircle(Offset(w * 0.75, h * 0.45), 2.5, dotPaint);

    // Center Blue Pin
    final pinPaint = Paint()
      ..color = const Color(0xFF1A73E8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx, center.dy - 3), 10, pinPaint);
    final pinBottom = Path()
      ..moveTo(center.dx - 8, center.dy - 1)
      ..lineTo(center.dx + 8, center.dy - 1)
      ..lineTo(center.dx, center.dy + 10)
      ..close();
    canvas.drawPath(pinBottom, pinPaint);

    // Inner white dot
    final whiteDot = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx, center.dy - 3), 4, whiteDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ApproximateMapPainter extends CustomPainter {
  final bool isSelected;
  const _ApproximateMapPainter({required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final orangeRoad = Paint()
      ..color = const Color(0xFFFB8C00)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final yellowRoad = Paint()
      ..color = const Color(0xFFFFB74D)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Road network
    final p1 = Path()
      ..moveTo(w * 0.55, h * 0.1)
      ..lineTo(w * 0.5, h * 0.28)
      ..lineTo(w * 0.38, h * 0.35)
      ..lineTo(w * 0.4, h * 0.55)
      ..lineTo(w * 0.3, h * 0.75)
      ..lineTo(w * 0.35, h * 0.9);
    canvas.drawPath(p1, orangeRoad);

    final p2 = Path()
      ..moveTo(w * 0.38, h * 0.35)
      ..lineTo(w * 0.8, h * 0.42)
      ..lineTo(w * 0.9, h * 0.55);
    canvas.drawPath(p2, yellowRoad);

    final p3 = Path()
      ..moveTo(w * 0.4, h * 0.55)
      ..lineTo(w * 0.8, h * 0.8);
    canvas.drawPath(p3, yellowRoad);

    // Small blue route markers
    final markerPaint = Paint()
      ..color = const Color(0xFF1A73E8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.38, h * 0.52), 3, markerPaint);
    canvas.drawCircle(Offset(w * 0.45, h * 0.78), 3, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
