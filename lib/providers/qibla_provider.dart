import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_app/services/qibla_service.dart';
import 'package:latlong2/latlong.dart';

enum QiblaLocationStatus {
  idle,
  loading,
  ready,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  error,
}

enum QiblaSensorStatus { unknown, available, unavailable }

class QiblaProvider extends ChangeNotifier {
  QiblaLocationStatus _locationStatus = QiblaLocationStatus.idle;
  QiblaSensorStatus _sensorStatus = QiblaSensorStatus.unknown;

  Position? _currentPosition;
  String? _locationName;
  String? _errorMessage;

  double? _qiblaBearing;
  double? _distanceKm;
  double _deviceHeading = 0.0;
  double _rawHeading = 0.0;
  double? _sensorAccuracy;
  bool _isAligned = false;

  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;

  /// Guards against concurrent or duplicate initialization.
  bool _initialized = false;
  Completer<void>? _initCompleter;

  // Getters
  QiblaLocationStatus get locationStatus => _locationStatus;
  QiblaSensorStatus get sensorStatus => _sensorStatus;
  Position? get currentPosition => _currentPosition;
  String? get locationName => _locationName;
  String? get errorMessage => _errorMessage;

  double get qiblaBearing => _qiblaBearing ?? 0.0;
  double get distanceKm => _distanceKm ?? 0.0;
  String get distanceText => _distanceKm != null
      ? QiblaService.formatDistance(_distanceKm!)
      : 'Calculating...';

  double get deviceHeading => _deviceHeading;
  double get rawHeading => _rawHeading;
  double? get sensorAccuracy => _sensorAccuracy;
  bool get isAligned => _isAligned;

  /// Whether the compass sensor is reporting low accuracy and needs calibration
  bool get needsCalibration =>
      _sensorAccuracy != null && _sensorAccuracy! > 25.0;

  /// Angle in degrees between phone orientation and Qibla (0° = pointing directly at Qibla)
  double get relativeAngle =>
      QiblaService.normalizeAngle(qiblaBearing - _deviceHeading);

  LatLng get userLatLng => _currentPosition != null
      ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
      : const LatLng(QiblaService.kaabaLatitude, QiblaService.kaabaLongitude);

  LatLng get kaabaLatLng =>
      const LatLng(QiblaService.kaabaLatitude, QiblaService.kaabaLongitude);

  // Constructor — no eager initialization; call initIfNeeded() when ready.
  QiblaProvider();

  /// Lazy initializer called by the Qibla screen. Runs only once.
  /// If already initialized or currently initializing, returns immediately
  /// or waits for the in-flight init to complete.
  Future<void> initIfNeeded() async {
    if (_initialized) return;
    if (_initCompleter != null) return _initCompleter!.future;

    _initCompleter = Completer<void>();
    try {
      _initCompass();
      await checkAndFetchLocation();
      _initialized = true;
    } finally {
      _initCompleter!.complete();
      _initCompleter = null;
    }
  }

  bool _hasInitialHeading = false;

  void _initCompass() {
    if (FlutterCompass.events == null) {
      _sensorStatus = QiblaSensorStatus.unavailable;
      notifyListeners();
      return;
    }

    _sensorStatus = QiblaSensorStatus.available;
    _compassSubscription?.cancel();

    _compassSubscription = FlutterCompass.events!.listen(
      (CompassEvent event) {
        final heading = event.heading;
        if (heading == null) return;

        final rawNorm = QiblaService.normalizeAngle(heading);
        _sensorAccuracy = event.accuracy;

        // Instant lock on first reading to prevent slow rotation/spinning from 0°
        if (!_hasInitialHeading) {
          _rawHeading = rawNorm;
          _deviceHeading = rawNorm;
          _hasInitialHeading = true;
          _updateAlignment();
          notifyListeners();
          return;
        }

        final diff = QiblaService.shortestAngleDifference(rawNorm, _deviceHeading);

        // Deadband filter: ignore micro-jitter below 0.8 degrees (prevents drifting on a flat table)
        if (diff.abs() < 0.8) {
          return;
        }

        _rawHeading = rawNorm;

        // Adaptive smoothing factor: snappy on deliberate turns (>15°), smooth on subtle hand shake
        final factor = diff.abs() > 15.0 ? 0.40 : 0.18;
        _deviceHeading = QiblaService.smoothAngle(
          _deviceHeading,
          _rawHeading,
          factor: factor,
        );

        _updateAlignment();
        notifyListeners();
      },
      onError: (e) {
        _sensorStatus = QiblaSensorStatus.unavailable;
        notifyListeners();
      },
    );
  }

  void _updateAlignment() {
    if (_qiblaBearing != null) {
      _isAligned = QiblaService.isAlignedWithQibla(
        _deviceHeading,
        _qiblaBearing!,
        toleranceDeg: 4.0,
      );
    }
  }

  Future<void> checkAndFetchLocation({bool requestIfNeeded = false}) async {
    _locationStatus = QiblaLocationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // 1. Check if location services are enabled on device
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      _locationStatus = QiblaLocationStatus.serviceDisabled;
      _errorMessage = 'Location services are disabled on your device.';
      notifyListeners();
      return;
    }

    // 2. Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestIfNeeded) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _locationStatus = QiblaLocationStatus.permissionDenied;
      _errorMessage = 'Location permission was denied.';
      notifyListeners();
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      _locationStatus = QiblaLocationStatus.permissionDeniedForever;
      _errorMessage =
          'Location permission is permanently denied. Please enable it in Settings.';
      notifyListeners();
      return;
    }

    // 3. Obtain initial GPS fix
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        _updateLocation(position);
      }

      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _updateLocation(position);
      _locationStatus = QiblaLocationStatus.ready;
      notifyListeners();

      // Reverse geocode in background to get friendly city/country name
      _resolveAddress(position.latitude, position.longitude);

      // 4. Listen to continuous location changes with distance filter (e.g. 50 meters)
      _startPositionStream();
    } catch (e) {
      if (_currentPosition != null) {
        // If we at least have last known position, keep ready status
        _locationStatus = QiblaLocationStatus.ready;
      } else {
        _locationStatus = QiblaLocationStatus.error;
        _errorMessage =
            'Unable to determine your GPS location. Please try again.';
      }
      notifyListeners();
    }
  }

  void _startPositionStream() {
    _positionSubscription?.cancel();
    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 50, // update when moved by 50 meters
          ),
        ).listen((Position newPosition) {
          _updateLocation(newPosition);
          notifyListeners();
        });
  }

  void _updateLocation(Position position) {
    _currentPosition = position;
    _qiblaBearing = QiblaService.calculateQiblaBearing(
      position.latitude,
      position.longitude,
    );
    _distanceKm = QiblaService.calculateDistanceKm(
      position.latitude,
      position.longitude,
    );
    _updateAlignment();
  }

  Future<void> _resolveAddress(double lat, double lng) async {
    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final city = p.locality?.isNotEmpty == true
            ? p.locality!
            : (p.subAdministrativeArea?.isNotEmpty == true
                  ? p.subAdministrativeArea!
                  : (p.administrativeArea ?? ''));
        final country = p.country ?? '';

        if (city.isNotEmpty && country.isNotEmpty) {
          _locationName = '$city, $country';
        } else if (city.isNotEmpty) {
          _locationName = city;
        } else if (country.isNotEmpty) {
          _locationName = country;
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Allows re-initialization (e.g. after user grants permission from error screen).
  void resetInitialization() {
    _initialized = false;
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }
}
