import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReaderFontSize { small, normal, large }

extension ReaderFontSizeX on ReaderFontSize {
  double get scale {
    switch (this) {
      case ReaderFontSize.small:
        return 0.85;
      case ReaderFontSize.normal:
        return 1.0;
      case ReaderFontSize.large:
        return 1.20;
    }
  }

  double get sliderValue => index.toDouble();

  String get label {
    switch (this) {
      case ReaderFontSize.small:
        return "SMALL";
      case ReaderFontSize.normal:
        return "NORMAL";
      case ReaderFontSize.large:
        return "LARGE";
    }
  }
}

class FontSizeProvider extends ChangeNotifier {
  static const _prefsKey = 'app_font_size';

  ReaderFontSize _fontSize = ReaderFontSize.normal;
  ReaderFontSize get fontSize => _fontSize;
  double get scale => _fontSize.scale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_prefsKey);
    if (savedIndex != null && savedIndex < ReaderFontSize.values.length) {
      _fontSize = ReaderFontSize.values[savedIndex];
    }
  }

  Future<void> setFontSize(double sliderValue) async {
    final newSize = ReaderFontSize.values[sliderValue.round()];
    if (newSize == _fontSize) return;
    _fontSize = newSize;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, newSize.index);
  }
}
