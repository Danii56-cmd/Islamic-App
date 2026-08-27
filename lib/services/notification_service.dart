import 'dart:developer' as dev;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String prayerChannelId = 'prayer_channel';
  static const String prayerChannelName = 'Prayer Notifications';
  static const String prayerChannelDescription =
      'Notifications for daily Islamic prayers with Azan sound';
  static const String azanSoundResource = 'azan';

  static const Map<String, int> prayerIds = {
    'fajr': 1,
    'sunrise': 2,
    'dhuhr': 3,
    'asr': 4,
    'maghrib': 5,
    'isha': 6,
  };

  int getPrayerId(String prayerName) {
    return prayerIds[prayerName.toLowerCase()] ??
        prayerName.toLowerCase().hashCode;
  }

  Future<void> init() async {
    // Initialize timezone database and detect local timezone
    tz.initializeTimeZones();
    try {
      final dynamic currentTimeZone = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = currentTimeZone is String
          ? currentTimeZone
          : currentTimeZone.toString();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      dev.log('Could not obtain local timezone, falling back to UTC: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // Android initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS/macOS initialization
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        dev.log('Notification tapped with payload: ${response.payload}');
      },
    );

    // Create custom notification channel with Azan sound for Android
    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      prayerChannelId,
      prayerChannelName,
      description: prayerChannelDescription,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(azanSoundResource),
      enableVibration: true,
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(androidChannel);
    }
  }

  Future<bool> requestPermissions() async {
    bool granted = false;

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      final notifGranted =
          await androidImplementation.requestNotificationsPermission();
      final exactAlarmGranted =
          await androidImplementation.requestExactAlarmsPermission();
      granted = (notifGranted ?? false) && (exactAlarmGranted ?? true);
    }

    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosImplementation != null) {
      final iosGranted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = iosGranted ?? false;
    }

    return granted;
  }

  NotificationDetails _getNotificationDetails(String prayerName) {
    const sound = RawResourceAndroidNotificationSound(azanSoundResource);

    final androidDetails = AndroidNotificationDetails(
      prayerChannelId,
      prayerChannelName,
      channelDescription: prayerChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: sound,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.notification,
      ticker: '$prayerName Prayer Time',
    );

    const darwinDetails = DarwinNotificationDetails(
      sound: '$azanSoundResource.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );
  }

  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    // If the scheduled time is in the past, calculate the next occurrence (tomorrow at same time)
    DateTime scheduledDate = prayerTime;
    final now = DateTime.now();
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

    dev.log(
      'Scheduling notification for $prayerName (ID: $id) at $tzDateTime with Azan sound',
    );

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: 'Time for $prayerName Prayer',
      body: 'It is time for the $prayerName prayer. Come to prayer, come to success.',
      scheduledDate: tzDateTime,
      notificationDetails: _getNotificationDetails(prayerName),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: prayerName,
    );
  }

  Future<void> cancelPrayerNotification(int id) async {
    dev.log('Cancelling notification with ID: $id');
    await _notificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllPrayerNotifications() async {
    dev.log('Cancelling all prayer notifications');
    await _notificationsPlugin.cancelAll();
  }
}
