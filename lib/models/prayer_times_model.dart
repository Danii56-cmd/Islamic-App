class PrayerTimesModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  /// Gregorian date this timing set applies to (e.g. "18 Aug 2026").
  final String gregorianDate;

  /// Hijri date string as returned by the API (e.g. "24 Safar 1448").
  final String hijriDate;

  const PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.gregorianDate,
    required this.hijriDate,
  });

  /// Ordered list of (name, time) pairs — used to drive the prayer list UI
  /// and to work out which prayer is "next".
  List<PrayerEntry> get entries => [
    PrayerEntry('Fajr', fajr),
    PrayerEntry('Sunrise', sunrise),
    PrayerEntry('Dhuhr', dhuhr),
    PrayerEntry('Asr', asr),
    PrayerEntry('Maghrib', maghrib),
    PrayerEntry('Isha', isha),
  ];

  /// `date.hijri` blocks.
  factory PrayerTimesModel.fromJson(
    Map<String, dynamic> json,
    DateTime forDate,
  ) {
    final timings = json['timings'] as Map<String, dynamic>;
    final dateBlock = json['date'] as Map<String, dynamic>;
    final hijri = dateBlock['hijri'] as Map<String, dynamic>;

    DateTime parseTime(String raw) {
      // Al Adhan sometimes appends " (PKT)" style timezone notes — strip them.
      final clean = raw.split(' ').first;
      final parts = clean.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(forDate.year, forDate.month, forDate.day, hour, minute);
    }

    return PrayerTimesModel(
      fajr: parseTime(timings['Fajr']),
      sunrise: parseTime(timings['Sunrise']),
      dhuhr: parseTime(timings['Dhuhr']),
      asr: parseTime(timings['Asr']),
      maghrib: parseTime(timings['Maghrib']),
      isha: parseTime(timings['Isha']),
      gregorianDate: dateBlock['readable'] as String? ?? '',
      hijriDate: '${hijri['day']} ${hijri['month']['en']} ${hijri['year']}',
    );
  }
}

class PrayerEntry {
  final String name;
  final DateTime time;
  const PrayerEntry(this.name, this.time);
}
