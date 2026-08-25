class SurahModel {
  final int number;
  final String name; // Arabic name, e.g. "الفاتحة"
  final String englishName; // e.g. "Al-Faatiha"
  final String englishNameTranslation; // e.g. "The Opening"
  final String revelationType; // "Meccan" | "Medinan"
  final int numberOfAyahs;

  const SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      revelationType: json['revelationType'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
    );
  }

  String get subtitle =>
      '$englishNameTranslation  •  $numberOfAyahs Verses  •  $revelationType';
}

class AyahModel {
  final int numberInSurah;
  final int numberInQuran;
  final String arabicText;
  final String translation;
  final String? audioUrl;

  const AyahModel({
    required this.numberInSurah,
    required this.numberInQuran,
    required this.arabicText,
    required this.translation,
    this.audioUrl,
  });

  /// Direct high quality CDN audio URL for the recitation of this Ayah
  String get effectiveAudioUrl {
    if (audioUrl != null && audioUrl!.trim().isNotEmpty) {
      return audioUrl!;
    }
    return 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$numberInQuran.mp3';
  }

  /// Stable key used for bookmarking/persistence, independent of surah.
  String get key => 'ayah_$numberInQuran';
}
