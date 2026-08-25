import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/models/surah_model.dart';
import 'package:islamic_app/providers/quran_provider.dart';
import 'package:islamic_app/services/quran_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeQuranService extends QuranService {
  @override
  Future<List<SurahModel>> fetchSurahList() async {
    return [
      const SurahModel(
        number: 1,
        name: 'سُورَةُ ٱلْفَاتِحَةِ',
        englishName: 'Al-Faatiha',
        englishNameTranslation: 'The Opening',
        numberOfAyahs: 7,
        revelationType: 'Meccan',
      ),
      const SurahModel(
        number: 2,
        name: 'سُورَةُ البَقَرَةِ',
        englishName: 'Al-Baqara',
        englishNameTranslation: 'The Cow',
        numberOfAyahs: 286,
        revelationType: 'Medinan',
      ),
      const SurahModel(
        number: 18,
        name: 'سُورَةُ الكَهۡفِ',
        englishName: 'Al-Kahf',
        englishNameTranslation: 'The Cave',
        numberOfAyahs: 110,
        revelationType: 'Meccan',
      ),
      const SurahModel(
        number: 36,
        name: 'سُورَةُ ي يسٓ',
        englishName: 'Yaseen',
        englishNameTranslation: 'Yaseen',
        numberOfAyahs: 83,
        revelationType: 'Meccan',
      ),
    ];
  }

  @override
  Future<List<AyahModel>> fetchSurahAyahs(int surahNumber) async {
    return [
      const AyahModel(
        numberInSurah: 1,
        numberInQuran: 1,
        arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      ),
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranProvider SharedPreferences persistence', () {
    test('Defaults to Surah 18 (Al-Kahf) if no saved preference exists', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = QuranProvider(service: FakeQuranService());
      await provider.init();

      expect(provider.currentSurah?.number, equals(18));
      expect(provider.currentSurah?.englishName, equals('Al-Kahf'));
    });

    test('Saves selected Surah to SharedPreferences on fetchSurah', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = QuranProvider(service: FakeQuranService());
      await provider.init();

      // Change Surah to Surah Yaseen (36)
      await provider.fetchSurah(36);
      expect(provider.currentSurah?.number, equals(36));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('quran_last_selected_surah'), equals(36));
    });

    test('Restores saved Surah from SharedPreferences on next app start', () async {
      // Simulate exiting app when Surah 2 (Al-Baqara) was active
      SharedPreferences.setMockInitialValues({
        'quran_last_selected_surah': 2,
      });

      final provider = QuranProvider(service: FakeQuranService());
      await provider.init();

      // Should automatically be on Surah 2
      expect(provider.currentSurah?.number, equals(2));
      expect(provider.currentSurah?.englishName, equals('Al-Baqara'));
    });
  });
}
