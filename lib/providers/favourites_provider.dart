import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/models/favourites_model.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _ayahsKey = 'favorite_ayahs_key';
  static const String _duasKey = 'favorite_duas_key';

  final List<FavoriteAyah> _favoriteAyahs = [];
  final List<FavoriteDua> _favoriteDuas = [];

  bool _isInitialized = false;

  FavoritesProvider() {
    init();
  }

  bool get isInitialized => _isInitialized;
  List<FavoriteAyah> get favoriteAyahs => List.unmodifiable(_favoriteAyahs);
  List<FavoriteDua> get favoriteDuas => List.unmodifiable(_favoriteDuas);
  int get totalFavoritesCount => _favoriteAyahs.length + _favoriteDuas.length;

  Future<void> init() async {
    if (_isInitialized) return;
    await _loadFromPrefs();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ayahsJsonList = prefs.getStringList(_ayahsKey);

      if (ayahsJsonList != null) {
        _favoriteAyahs.clear();
        for (final item in ayahsJsonList) {
          try {
            final map = jsonDecode(item) as Map<String, dynamic>;
            _favoriteAyahs.add(FavoriteAyah.fromJson(map));
          } catch (e) {
            debugPrint('Error parsing saved ayah: $e');
          }
        }
      }

      final duasJsonList = prefs.getStringList(_duasKey);
      if (duasJsonList != null) {
        _favoriteDuas.clear();
        for (final item in duasJsonList) {
          try {
            final map = jsonDecode(item) as Map<String, dynamic>;
            _favoriteDuas.add(FavoriteDua.fromJson(map));
          } catch (e) {
            debugPrint('Error parsing saved dua: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading favorites from SharedPreferences: $e');
    }
  }

  Future<void> _saveAyahsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ayahsJsonList = _favoriteAyahs
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      await prefs.setStringList(_ayahsKey, ayahsJsonList);
    } catch (e) {
      debugPrint('Error saving ayahs to SharedPreferences: $e');
    }
  }

  Future<void> _saveDuasToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final duasJsonList = _favoriteDuas
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      await prefs.setStringList(_duasKey, duasJsonList);
    } catch (e) {
      debugPrint('Error saving duas to SharedPreferences: $e');
    }
  }

  // AYAH FAVORITES
  bool isAyahFavorite({required int surahNumber, required int ayahNumber}) {
    return _favoriteAyahs.any(
      (ayah) =>
          ayah.surahNumber == surahNumber && ayah.ayahNumber == ayahNumber,
    );
  }

  void toggleAyahFavorite(FavoriteAyah ayah) {
    final index = _favoriteAyahs.indexWhere(
      (item) =>
          item.surahNumber == ayah.surahNumber &&
          item.ayahNumber == ayah.ayahNumber,
    );

    if (index >= 0) {
      _favoriteAyahs.removeAt(index);
    } else {
      _favoriteAyahs.add(ayah);
    }

    notifyListeners();
    _saveAyahsToPrefs();
  }

  // DUA FAVORITES
  bool isDuaFavorite(String id) {
    return _favoriteDuas.any((dua) => dua.id == id);
  }

  void toggleDuaFavorite(FavoriteDua dua) {
    final index = _favoriteDuas.indexWhere((item) => item.id == dua.id);

    if (index >= 0) {
      _favoriteDuas.removeAt(index);
    } else {
      _favoriteDuas.add(dua);
    }

    notifyListeners();
    _saveDuasToPrefs();
  }

  // REMOVE
  void removeAyah(FavoriteAyah ayah) {
    _favoriteAyahs.removeWhere(
      (item) =>
          item.surahNumber == ayah.surahNumber &&
          item.ayahNumber == ayah.ayahNumber,
    );

    notifyListeners();
    _saveAyahsToPrefs();
  }

  void removeDua(FavoriteDua dua) {
    _favoriteDuas.removeWhere((item) => item.id == dua.id);

    notifyListeners();
    _saveDuasToPrefs();
  }

  // CLEAR
  void clearAyahs() {
    _favoriteAyahs.clear();
    notifyListeners();
    _saveAyahsToPrefs();
  }

  void clearDuas() {
    _favoriteDuas.clear();
    notifyListeners();
    _saveDuasToPrefs();
  }

  void clearAll() {
    _favoriteAyahs.clear();
    _favoriteDuas.clear();
    notifyListeners();
    _saveAyahsToPrefs();
    _saveDuasToPrefs();
  }
}
