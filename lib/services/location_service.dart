import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ResolvedLocation {
  final double latitude;
  final double longitude;
  final String city;
  final String country;

  const ResolvedLocation({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
  });

  String get label => city.isEmpty ? country : '$city, $country';
}

class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);
  @override
  String toString() => message;
}

class LocationService {
  Future<ResolvedLocation> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationServiceException(
        'Location services are turned off on this device.',
      );
    }

    // Only check permission — never request it here.
    // The LocationPermissionDialog is the single place that requests permission.
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      throw const LocationServiceException('Location permission denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Location permission permanently denied. Enable it from Settings.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    ).timeout(const Duration(seconds: 8));

    String city = '';
    String country = '';
    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        city = p.locality?.isNotEmpty == true
            ? p.locality!
            : (p.subAdministrativeArea ?? '');
        country = p.country ?? '';
      }
    } catch (_) {}

    return ResolvedLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      city: city,
      country: country,
    );
  }
}
