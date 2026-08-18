import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:islamic_app/models/surah_model.dart';

class QuranServiceException implements Exception {
  final String message;
  const QuranServiceException(this.message);
  @override
  String toString() => message;
}

/// Talks to the free, keyless AlQuran Cloud API
/// (https://alquran.cloud/api) for the surah index, ayah text
/// (Uthmani script) and an English translation (Saheeh International).
class QuranService {
  static const _baseUrl = 'https://api.alquran.cloud/v1';

  /// Fetches the list of all 114 surahs (name, ayah count, etc).
  Future<List<SurahModel>> fetchSurahList() async {
    final uri = Uri.parse('$_baseUrl/surah');
    final response = await _get(uri);
    final data = response['data'] as List<dynamic>;
    return data
        .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single surah's ayahs, paired Arabic + English
  /// translation, via the dual "editions" endpoint so both come back
  /// in one request.
  Future<List<AyahModel>> fetchSurahAyahs(int surahNumber) async {
    final uri = Uri.parse(
      '$_baseUrl/surah/$surahNumber/editions/quran-uthmani,en.sahih',
    );
    final response = await _get(uri);
    final editions = response['data'] as List<dynamic>;
    if (editions.length < 2) {
      throw const QuranServiceException('Unexpected Quran API response.');
    }

    final arabicAyahs = (editions[0]['ayahs'] as List<dynamic>);
    final translationAyahs = (editions[1]['ayahs'] as List<dynamic>);

    final ayahs = <AyahModel>[];
    for (var i = 0; i < arabicAyahs.length; i++) {
      final a = arabicAyahs[i] as Map<String, dynamic>;
      final t = translationAyahs[i] as Map<String, dynamic>;
      ayahs.add(
        AyahModel(
          numberInSurah: a['numberInSurah'] as int,
          numberInQuran: a['number'] as int,
          arabicText: a['text'] as String,
          translation: t['text'] as String,
        ),
      );
    }
    return ayahs;
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    late final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw QuranServiceException('Could not reach Quran service: $e');
    }
    if (response.statusCode != 200) {
      throw QuranServiceException(
        'Quran request failed (${response.statusCode}).',
      );
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
