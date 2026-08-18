import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:islamic_app/models/dua_model.dart';

/// Loads the curated du'a dataset bundled at `assets/duas.json`.
/// See the note in [DuaModel] for why this isn't a remote API call.
class DuasService {
  Future<List<DuaModel>> loadDuas() async {
    final raw = await rootBundle.loadString('assets/duas.json');
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => DuaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
