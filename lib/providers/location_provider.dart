import 'package:flutter/foundation.dart';
import 'package:islamic_app/services/location_service.dart';

enum LocationStatus { idle, loading, ready, error }

class LocationProvider extends ChangeNotifier {
  final LocationService _service;
  LocationProvider({LocationService? service})
    : _service = service ?? LocationService();

  LocationStatus status = LocationStatus.idle;
  ResolvedLocation? location;
  String? errorMessage;

  Future<void> fetchLocation() async {
    status = LocationStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      location = await _service.getCurrentLocation();
      status = LocationStatus.ready;
    } catch (e) {
      errorMessage = e.toString();
      status = LocationStatus.error;
    }
    notifyListeners();
  }
}
