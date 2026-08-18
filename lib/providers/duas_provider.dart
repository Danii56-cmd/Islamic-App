import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/models/dua_model.dart';
import 'package:islamic_app/services/duas_service.dart';

enum DuasLoadStatus { idle, loading, ready, error }

class DuasProvider extends ChangeNotifier {
  final DuasService _service;
  DuasProvider({DuasService? service}) : _service = service ?? DuasService();

  static const _favoritesKey = 'dua_favorites';

  DuasLoadStatus status = DuasLoadStatus.idle;
  String? errorMessage;

  List<DuaModel> _allDuas = [];
  List<DuaModel> filteredDuas = [];
  List<String> categories = [];
  String selectedCategory = 'All';

  final Set<String> _favoriteIds = {};
  bool isFavorite(DuaModel dua) => _favoriteIds.contains(dua.id);

  Future<void> init() async {
    status = DuasLoadStatus.loading;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      _favoriteIds.addAll(prefs.getStringList(_favoritesKey) ?? []);

      _allDuas = await _service.loadDuas();
      categories = ['All', ..._allDuas.map((d) => d.category).toSet()];
      filteredDuas = _allDuas;
      status = DuasLoadStatus.ready;
    } catch (e) {
      errorMessage = e.toString();
      status = DuasLoadStatus.error;
    }
    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    filteredDuas = category == 'All'
        ? _allDuas
        : _allDuas.where((d) => d.category == category).toList();
    notifyListeners();
  }

  void search(String query) {
    final base = selectedCategory == 'All'
        ? _allDuas
        : _allDuas.where((d) => d.category == selectedCategory);
    if (query.trim().isEmpty) {
      filteredDuas = base.toList();
    } else {
      final q = query.toLowerCase();
      filteredDuas = base
          .where(
            (d) =>
                d.title.toLowerCase().contains(q) ||
                d.translation.toLowerCase().contains(q),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(DuaModel dua) async {
    if (_favoriteIds.contains(dua.id)) {
      _favoriteIds.remove(dua.id);
    } else {
      _favoriteIds.add(dua.id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
  }
}
