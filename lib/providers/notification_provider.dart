import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:islamic_app/models/prayer_times_model.dart';
import 'package:islamic_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;

  NotificationProvider({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  static const String _prefGlobalKey = 'notifications_global_enabled';
  static const String _prefPrayersKey = 'notifications_prayer_settings';

  bool _isGlobalEnabled = true;
  Map<String, bool> _prayerSettings = {
    'Fajr': true,
    'Sunrise': false,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  PrayerTimesModel? _lastTimings;
  String? _lastScheduledKey;

  bool get isGlobalEnabled => _isGlobalEnabled;
  Map<String, bool> get prayerSettings => Map.unmodifiable(_prayerSettings);
  PrayerTimesModel? get lastTimings => _lastTimings;

  bool isPrayerEnabled(String prayerName) {
    for (final entry in _prayerSettings.entries) {
      if (entry.key.toLowerCase() == prayerName.toLowerCase()) {
        return entry.value;
      }
    }
    return true;
  }

  bool isPrayerActive(String prayerName) {
    return _isGlobalEnabled && isPrayerEnabled(prayerName);
  }

  Future<void> init() async {
    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(_prefGlobalKey)) {
        _isGlobalEnabled = prefs.getBool(_prefGlobalKey) ?? true;
      }

      final savedPrayersJson = prefs.getString(_prefPrayersKey);
      if (savedPrayersJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(savedPrayersJson);
        _prayerSettings = decoded.map(
          (key, value) => MapEntry(key, value as bool),
        );
      }
    } catch (e) {
      debugPrint('Error loading notification preferences: $e');
    }
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefGlobalKey, _isGlobalEnabled);
      await prefs.setString(_prefPrayersKey, jsonEncode(_prayerSettings));
    } catch (e) {
      debugPrint('Error saving notification preferences: $e');
    }
  }

  Future<void> toggleGlobal(bool enabled, [PrayerTimesModel? timings]) async {
    _isGlobalEnabled = enabled;
    notifyListeners();
    await _savePreferences();

    if (enabled) {
      await _notificationService.requestPermissions();
    }

    await syncWithPrayerTimes(timings ?? _lastTimings, force: true);
  }

  Future<void> togglePrayer(
    String prayerName,
    bool enabled, [
    PrayerTimesModel? timings,
  ]) async {
    String matchedKey = prayerName;
    for (final key in _prayerSettings.keys) {
      if (key.toLowerCase() == prayerName.toLowerCase()) {
        matchedKey = key;
        break;
      }
    }
    _prayerSettings[matchedKey] = enabled;
    notifyListeners();
    await _savePreferences();

    if (enabled && _isGlobalEnabled) {
      await _notificationService.requestPermissions();
    }

    await syncWithPrayerTimes(timings ?? _lastTimings, force: true);
  }

  Future<void> syncWithPrayerTimes(
    PrayerTimesModel? timings, {
    bool force = false,
  }) async {
    _lastTimings = timings;
    if (timings == null) return;

    final scheduleKey =
        '${_isGlobalEnabled}_${jsonEncode(_prayerSettings)}_${timings.gregorianDate}_${timings.fajr}_${timings.isha}';
    if (!force && _lastScheduledKey == scheduleKey) {
      return;
    }
    _lastScheduledKey = scheduleKey;

    await _notificationService.cancelAllPrayerNotifications();

    if (!_isGlobalEnabled) {
      return;
    }

    for (final entry in timings.entries) {
      if (isPrayerEnabled(entry.name)) {
        final id = _notificationService.getPrayerId(entry.name);
        await _notificationService.schedulePrayerNotification(
          id: id,
          prayerName: entry.name,
          prayerTime: entry.time,
        );
      }
    }
  }

  Future<bool> requestPermissions() async {
    return await _notificationService.requestPermissions();
  }
}
