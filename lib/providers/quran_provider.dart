import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/models/surah_model.dart';
import 'package:islamic_app/services/quran_service.dart';

enum QuranLoadStatus { idle, loading, ready, error }

class QuranProvider extends ChangeNotifier {
  final QuranService _service;
  QuranProvider({QuranService? service}) : _service = service ?? QuranService();

  static const _bookmarksKey = 'quran_bookmarked_ayahs';
  static const _lastSurahKey = 'quran_last_selected_surah';

  QuranLoadStatus surahListStatus = QuranLoadStatus.idle;
  QuranLoadStatus ayahsStatus = QuranLoadStatus.idle;
  String? errorMessage;

  List<SurahModel> allSurahs = [];
  List<SurahModel> filteredSurahs = [];

  SurahModel? currentSurah;
  List<AyahModel> currentAyahs = [];

  final Set<String> _bookmarkedKeys = {};
  bool isBookmarked(AyahModel ayah) => _bookmarkedKeys.contains(ayah.key);

  Future<void> init() async {
    await _loadBookmarks();
    await fetchSurahList();
    final savedSurahNumber = await _loadLastSelectedSurah();
    // Default to last selected Surah from SharedPreferences, or Surah 18 (Al-Kahf) for first time.
    await fetchSurah(savedSurahNumber ?? 18);
  }

  Future<void> fetchSurahList() async {
    surahListStatus = QuranLoadStatus.loading;
    notifyListeners();
    try {
      allSurahs = await _service.fetchSurahList();
      filteredSurahs = allSurahs;
      surahListStatus = QuranLoadStatus.ready;
    } catch (e) {
      errorMessage = e.toString();
      surahListStatus = QuranLoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> fetchSurah(int number) async {
    ayahsStatus = QuranLoadStatus.loading;
    notifyListeners();
    try {
      currentAyahs = await _service.fetchSurahAyahs(number);
      currentSurah = allSurahs.isNotEmpty
          ? allSurahs.firstWhere(
              (s) => s.number == number,
              orElse: () => allSurahs.first,
            )
          : null;
      ayahsStatus = QuranLoadStatus.ready;
      await _saveLastSelectedSurah(number);
    } catch (e) {
      errorMessage = e.toString();
      ayahsStatus = QuranLoadStatus.error;
    }
    notifyListeners();
  }

  void searchSurahs(String query) {
    if (query.trim().isEmpty) {
      filteredSurahs = allSurahs;
    } else {
      final q = query.toLowerCase();
      filteredSurahs = allSurahs
          .where(
            (s) =>
                s.englishName.toLowerCase().contains(q) ||
                s.englishNameTranslation.toLowerCase().contains(q) ||
                s.name.contains(query) ||
                s.number.toString() == query,
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> toggleBookmark(AyahModel ayah) async {
    if (_bookmarkedKeys.contains(ayah.key)) {
      _bookmarkedKeys.remove(ayah.key);
    } else {
      _bookmarkedKeys.add(ayah.key);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_bookmarksKey, _bookmarkedKeys.toList());
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    _bookmarkedKeys.addAll(prefs.getStringList(_bookmarksKey) ?? []);
  }

  Future<void> _saveLastSelectedSurah(int number) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSurahKey, number);
    } catch (_) {}
  }

  Future<int?> _loadLastSelectedSurah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_lastSurahKey);
    } catch (_) {
      return null;
    }
  }
}
