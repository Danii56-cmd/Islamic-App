import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/models/favourites_model.dart';
import 'package:islamic_app/providers/favourites_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('FavoritesProvider Tests', () {
    test('Can toggle and remove favorite Ayah', () async {
      final provider = FavoritesProvider();
      await provider.init();

      const ayah1 = FavoriteAyah(
        surahNumber: 1,
        surahName: 'Al-Faatiha',
        ayahNumber: 1,
        arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      );

      expect(provider.isAyahFavorite(surahNumber: 1, ayahNumber: 1), isFalse);

      provider.toggleAyahFavorite(ayah1);
      expect(provider.isAyahFavorite(surahNumber: 1, ayahNumber: 1), isTrue);
      expect(provider.favoriteAyahs.length, 1);

      provider.toggleAyahFavorite(ayah1);
      expect(provider.isAyahFavorite(surahNumber: 1, ayahNumber: 1), isFalse);
      expect(provider.favoriteAyahs.length, 0);

      provider.toggleAyahFavorite(ayah1);
      provider.removeAyah(ayah1);
      expect(provider.favoriteAyahs.length, 0);
    });

    test('Can toggle and remove favorite Dua', () async {
      final provider = FavoritesProvider();
      await provider.init();

      const dua1 = FavoriteDua(
        id: 'dua_1',
        title: 'Morning Dua',
        arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
        translation: 'We have entered a new morning and with it all dominion belongs to Allah.',
        category: 'Morning & Evening',
      );

      expect(provider.isDuaFavorite('dua_1'), isFalse);

      provider.toggleDuaFavorite(dua1);
      expect(provider.isDuaFavorite('dua_1'), isTrue);
      expect(provider.favoriteDuas.length, 1);

      provider.toggleDuaFavorite(dua1);
      expect(provider.isDuaFavorite('dua_1'), isFalse);
      expect(provider.favoriteDuas.length, 0);
    });

    test('Can clear all favorites', () async {
      final provider = FavoritesProvider();
      await provider.init();

      const ayah = FavoriteAyah(
        surahNumber: 2,
        surahName: 'Al-Baqarah',
        ayahNumber: 255,
        arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of existence.',
      );

      const dua = FavoriteDua(
        id: 'dua_travel',
        title: 'Travel Dua',
        arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا',
        translation: 'Glory unto Him Who created this for our use.',
      );

      provider.toggleAyahFavorite(ayah);
      provider.toggleDuaFavorite(dua);
      expect(provider.totalFavoritesCount, 2);

      provider.clearAll();
      expect(provider.totalFavoritesCount, 0);
      expect(provider.favoriteAyahs.isEmpty, isTrue);
      expect(provider.favoriteDuas.isEmpty, isTrue);
    });
  });
}
