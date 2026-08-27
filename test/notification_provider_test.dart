import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/models/prayer_times_model.dart';
import 'package:islamic_app/providers/notification_provider.dart';
import 'package:islamic_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeNotificationService implements NotificationService {
  final List<Map<String, dynamic>> scheduled = [];
  final List<int> cancelledIds = [];
  bool cancelAllCalled = false;
  bool permissionsRequested = false;

  @override
  int getPrayerId(String prayerName) {
    return NotificationService.prayerIds[prayerName.toLowerCase()] ??
        prayerName.toLowerCase().hashCode;
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    scheduled.add({
      'id': id,
      'prayerName': prayerName,
      'prayerTime': prayerTime,
    });
  }

  @override
  Future<void> cancelPrayerNotification(int id) async {
    cancelledIds.add(id);
    scheduled.removeWhere((s) => s['id'] == id);
  }

  @override
  Future<void> cancelAllPrayerNotifications() async {
    cancelAllCalled = true;
    scheduled.clear();
  }

  @override
  Future<bool> requestPermissions() async {
    permissionsRequested = true;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeNotificationService fakeService;
  late PrayerTimesModel sampleTimings;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fakeService = FakeNotificationService();

    sampleTimings = PrayerTimesModel(
      fajr: DateTime(2026, 8, 27, 4, 35),
      sunrise: DateTime(2026, 8, 27, 6, 0),
      dhuhr: DateTime(2026, 8, 27, 12, 30),
      asr: DateTime(2026, 8, 27, 16, 15),
      maghrib: DateTime(2026, 8, 27, 19, 0),
      isha: DateTime(2026, 8, 27, 20, 30),
      gregorianDate: '27 Aug 2026',
      hijriDate: '13 Safar 1448',
    );
  });

  group('NotificationProvider Tests', () {
    test('Default preferences have global enabled and 5 daily prayers enabled', () async {
      final provider = NotificationProvider(notificationService: fakeService);
      await provider.init();

      expect(provider.isGlobalEnabled, isTrue);
      expect(provider.isPrayerEnabled('Fajr'), isTrue);
      expect(provider.isPrayerEnabled('Dhuhr'), isTrue);
      expect(provider.isPrayerEnabled('Asr'), isTrue);
      expect(provider.isPrayerEnabled('Maghrib'), isTrue);
      expect(provider.isPrayerEnabled('Isha'), isTrue);
      expect(provider.isPrayerEnabled('Sunrise'), isFalse);
    });

    test('Schedules enabled prayers when synchronizing with prayer times', () async {
      final provider = NotificationProvider(notificationService: fakeService);
      await provider.init();

      await provider.syncWithPrayerTimes(sampleTimings);

      expect(fakeService.cancelAllCalled, isTrue);
      // 5 prayers enabled by default (Fajr, Dhuhr, Asr, Maghrib, Isha)
      expect(fakeService.scheduled.length, 5);
      final scheduledNames = fakeService.scheduled.map((e) => e['prayerName']).toSet();
      expect(scheduledNames, containsAll(['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']));
      expect(scheduledNames.contains('Sunrise'), isFalse);
    });

    test('Disabling global notifications cancels all scheduled notifications', () async {
      final provider = NotificationProvider(notificationService: fakeService);
      await provider.init();
      await provider.syncWithPrayerTimes(sampleTimings);

      expect(fakeService.scheduled.length, 5);

      await provider.toggleGlobal(false, sampleTimings);
      expect(provider.isGlobalEnabled, isFalse);
      expect(fakeService.scheduled.isEmpty, isTrue);
      expect(provider.isPrayerActive('Fajr'), isFalse);
    });

    test('Disabling individual prayer only cancels that prayer', () async {
      final provider = NotificationProvider(notificationService: fakeService);
      await provider.init();
      await provider.syncWithPrayerTimes(sampleTimings);

      expect(fakeService.scheduled.length, 5);

      // Disable Fajr
      await provider.togglePrayer('Fajr', false, sampleTimings);
      expect(provider.isPrayerEnabled('Fajr'), isFalse);
      expect(fakeService.scheduled.length, 4);
      final scheduledNames = fakeService.scheduled.map((e) => e['prayerName']).toSet();
      expect(scheduledNames.contains('Fajr'), isFalse);
      expect(scheduledNames, containsAll(['Dhuhr', 'Asr', 'Maghrib', 'Isha']));

      // Enable Sunrise
      await provider.togglePrayer('Sunrise', true, sampleTimings);
      expect(provider.isPrayerEnabled('Sunrise'), isTrue);
      expect(fakeService.scheduled.length, 5);
      final updatedNames = fakeService.scheduled.map((e) => e['prayerName']).toSet();
      expect(updatedNames.contains('Sunrise'), isTrue);
    });

    test('Preferences persist across provider instances', () async {
      final provider1 = NotificationProvider(notificationService: fakeService);
      await provider1.init();
      await provider1.togglePrayer('Asr', false);
      await provider1.toggleGlobal(true);

      final provider2 = NotificationProvider(notificationService: fakeService);
      await provider2.init();

      expect(provider2.isGlobalEnabled, isTrue);
      expect(provider2.isPrayerEnabled('Asr'), isFalse);
      expect(provider2.isPrayerEnabled('Fajr'), isTrue);
    });

    test('getPrayerId provides deterministic IDs', () {
      final service = NotificationService();
      expect(service.getPrayerId('Fajr'), 1);
      expect(service.getPrayerId('fajr'), 1);
      expect(service.getPrayerId('Sunrise'), 2);
      expect(service.getPrayerId('Dhuhr'), 3);
      expect(service.getPrayerId('Asr'), 4);
      expect(service.getPrayerId('Maghrib'), 5);
      expect(service.getPrayerId('Isha'), 6);
    });
  });
}
