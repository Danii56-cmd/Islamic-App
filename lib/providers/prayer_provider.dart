import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:islamic_app/models/prayer_times_model.dart';
import 'package:islamic_app/services/prayer_service.dart';

enum PrayerLoadStatus { idle, loading, ready, error }

class PrayerProvider extends ChangeNotifier {
  final PrayerService _service;
  PrayerProvider({PrayerService? service})
    : _service = service ?? PrayerService();

  PrayerLoadStatus status = PrayerLoadStatus.idle;
  PrayerTimesModel? timings;
  String? errorMessage;
  CalculationMethod method = CalculationMethod.karachi;

  Timer? _ticker;
  PrayerEntry? _nextPrayer;
  Duration _timeUntilNext = Duration.zero;

  PrayerEntry? get nextPrayer => _nextPrayer;
  Duration get timeUntilNext => _timeUntilNext;

  String get activePrayerName {
    if (timings == null) return '';
    final entries = timings!.entries;
    final now = DateTime.now();
    String active = entries.first.name;
    for (final e in entries) {
      if (!now.isBefore(e.time)) {
        active = e.name;
      }
    }
    return active;
  }

  Future<void> fetchTimings({
    required double latitude,
    required double longitude,
  }) async {
    status = PrayerLoadStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      timings = await _service.fetchTimings(
        latitude: latitude,
        longitude: longitude,
        method: method,
      );
      status = PrayerLoadStatus.ready;
      _startTicker();
    } catch (e) {
      errorMessage = e.toString();
      status = PrayerLoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> changeMethod(
    CalculationMethod newMethod, {
    required double latitude,
    required double longitude,
  }) async {
    method = newMethod;
    await fetchTimings(latitude: latitude, longitude: longitude);
  }

  void _startTicker() {
    _ticker?.cancel();
    _computeNext();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _computeNext());
  }

  void _computeNext() {
    if (timings == null) return;
    final now = DateTime.now();
    final entries = timings!.entries;

    PrayerEntry? next;
    for (final e in entries) {
      if (e.time.isAfter(now)) {
        next = e;
        break;
      }
    }

    next ??= entries.first;

    _nextPrayer = next;
    _timeUntilNext = next.time.isAfter(now)
        ? next.time.difference(now)
        : Duration.zero;
    notifyListeners();
  }

  String formattedCountdown() {
    final h = _timeUntilNext.inHours.toString().padLeft(2, '0');
    final m = (_timeUntilNext.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_timeUntilNext.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
