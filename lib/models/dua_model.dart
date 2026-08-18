class DuaModel {
  final String id;
  final String category;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String reference;

  const DuaModel({
    required this.id,
    required this.category,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.reference,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      arabicText: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      reference: json['reference'] as String,
    );
  }
}
