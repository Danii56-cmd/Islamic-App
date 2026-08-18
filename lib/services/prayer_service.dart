import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:islamic_app/models/prayer_times_model.dart';

class PrayerServiceException implements Exception {
  final String message;
  const PrayerServiceException(this.message);
  @override
  String toString() => message;
}

/// Calculation methods supported by Al Adhan's `method` query param.
/// (Full list: https://aladhan.com/calculation-methods)
enum CalculationMethod {
  karachi(1, 'University of Islamic Sciences, Karachi'),
  isna(2, 'Islamic Society of North America (ISNA)'),
  mwl(3, 'Muslim World League'),
  ummAlQura(4, 'Umm Al-Qura University, Makkah'),
  egyptian(5, 'Egyptian General Authority of Survey'),
  tehran(7, 'Institute of Geophysics, Tehran'),
  diyanet(13, 'Turkey (Diyanet)');

  final int id;
  final String label;
  const CalculationMethod(this.id, this.label);
}

/// Talks to the free, keyless Al Adhan API
/// (https://aladhan.com/prayer-times-api) for daily prayer timings.
class PrayerService {
  static const _baseUrl = 'https://api.aladhan.com/v1';

  Future<PrayerTimesModel> fetchTimings({
    required double latitude,
    required double longitude,
    DateTime? date,
    CalculationMethod method = CalculationMethod.karachi,
  }) async {
    final forDate = date ?? DateTime.now();
    final dateStr =
        '${forDate.day.toString().padLeft(2, '0')}-${forDate.month.toString().padLeft(2, '0')}-${forDate.year}';

    final uri = Uri.parse('$_baseUrl/timings/$dateStr').replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'method': method.id.toString(),
      },
    );

    late final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw PrayerServiceException('Could not reach prayer times service: $e');
    }

    if (response.statusCode != 200) {
      throw PrayerServiceException(
        'Prayer times request failed (${response.statusCode}).',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw const PrayerServiceException('Unexpected prayer times response.');
    }

    return PrayerTimesModel.fromJson(data, forDate);
  }
}
