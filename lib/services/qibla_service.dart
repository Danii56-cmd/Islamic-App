import 'dart:math' as math;

/// Mathematical service for Qibla bearing, distance to Kaaba, and sensor smoothing.
class QiblaService {
  /// Exact geographic coordinates of the Kaaba in Makkah, Saudi Arabia.
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  /// Earth's mean radius in kilometers.
  static const double earthRadiusKm = 6371.0;

  /// Calculates the Great-Circle forward azimuth (initial bearing) from the user's
  /// coordinates [latitude, longitude] to the Kaaba in degrees (0° to 360° clockwise from True North).
  ///
  /// Formula:
  /// θ = atan2( sin(Δlong) * cos(lat2),
  ///            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(Δlong) )
  static double calculateQiblaBearing(double latitude, double longitude) {
    // If coordinates are exactly Kaaba or invalid
    if ((latitude - kaabaLatitude).abs() < 1e-6 &&
        (longitude - kaabaLongitude).abs() < 1e-6) {
      return 0.0;
    }

    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(kaabaLatitude);
    final dLng = _toRadians(kaabaLongitude - longitude);

    final y = math.sin(dLng) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    final initialBearingRad = math.atan2(y, x);
    final initialBearingDeg = _toDegrees(initialBearingRad);

    return normalizeAngle(initialBearingDeg);
  }

  /// Calculates the Great-Circle distance in kilometers between the user's location
  /// and the Kaaba using the Haversine formula.
  static double calculateDistanceKm(double latitude, double longitude) {
    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(kaabaLatitude);
    final dLat = _toRadians(kaabaLatitude - latitude);
    final dLng = _toRadians(kaabaLongitude - longitude);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  /// Formats distance in km (e.g. "3,560 km" or "85 km").
  static String formatDistance(double distanceKm) {
    if (distanceKm >= 1000) {
      final rounded = distanceKm.round();
      final thousands = rounded ~/ 1000;
      final remainder = rounded % 1000;
      return '$thousands,${remainder.toString().padLeft(3, '0')} km';
    }
    return '${distanceKm.round()} km';
  }

  /// Normalizes any angle in degrees to [0.0, 360.0).
  static double normalizeAngle(double angle) {
    var normalized = angle % 360.0;
    if (normalized < 0) {
      normalized += 360.0;
    }
    return normalized;
  }

  /// Calculates the shortest angular difference between [targetAngle] and [currentAngle] in degrees (-180° to +180°).
  static double shortestAngleDifference(
    double targetAngle,
    double currentAngle,
  ) {
    var diff = (targetAngle - currentAngle) % 360.0;
    if (diff > 180.0) diff -= 360.0;
    if (diff < -180.0) diff += 360.0;
    return diff;
  }

  /// Applies exponential moving average smoothing to angular readings with wrap-around at 0°/360°.
  /// [currentSmoothed]: current smoothed heading.
  /// [newRaw]: incoming raw sensor reading.
  /// [factor]: smoothing factor between 0.0 (no change) and 1.0 (immediate jump). Default 0.25.
  static double smoothAngle(
    double currentSmoothed,
    double newRaw, {
    double factor = 0.25,
  }) {
    final diff = shortestAngleDifference(newRaw, currentSmoothed);
    return normalizeAngle(currentSmoothed + diff * factor);
  }

  /// Determines whether the device heading is aligned with the Qibla bearing within [toleranceDeg] (default 3°).
  static bool isAlignedWithQibla(
    double deviceHeading,
    double qiblaBearing, {
    double toleranceDeg = 3.0,
  }) {
    final diff = shortestAngleDifference(qiblaBearing, deviceHeading).abs();
    return diff <= toleranceDeg;
  }

  /// Converts a bearing in degrees (0..360) to a cardinal direction string (e.g. "N", "NE", "E", "SE", "S", "SW", "W", "NW").
  static String getCardinalDirection(double bearing) {
    const directions = [
      'N', 'NNE', 'NE', 'ENE',
      'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW',
      'W', 'WNW', 'NW', 'NNW'
    ];
    final normalized = normalizeAngle(bearing);
    final index = ((normalized + 11.25) % 360) ~/ 22.5;
    return directions[index.clamp(0, 15)];
  }

  static double _toRadians(double deg) => deg * (math.pi / 180.0);
  static double _toDegrees(double rad) => rad * (180.0 / math.pi);
}
