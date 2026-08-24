class FavoriteAyah {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String arabic;
  final String translation;

  const FavoriteAyah({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.arabic,
    required this.translation,
  });

  Map<String, dynamic> toJson() => {
    'surahNumber': surahNumber,
    'surahName': surahName,
    'ayahNumber': ayahNumber,
    'arabic': arabic,
    'translation': translation,
  };

  factory FavoriteAyah.fromJson(Map<String, dynamic> json) => FavoriteAyah(
    surahNumber: json['surahNumber'] as int,
    surahName: json['surahName'] as String,
    ayahNumber: json['ayahNumber'] as int,
    arabic: json['arabic'] as String,
    translation: json['translation'] as String,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAyah &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => surahNumber.hashCode ^ ayahNumber.hashCode;
}

class FavoriteDua {
  final String id;
  final String title;
  final String arabic;
  final String translation;
  final String category;
  final String reference;

  const FavoriteDua({
    required this.id,
    required this.title,
    required this.arabic,
    required this.translation,
    this.category = '',
    this.reference = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'arabic': arabic,
    'translation': translation,
    'category': category,
    'reference': reference,
  };

  factory FavoriteDua.fromJson(Map<String, dynamic> json) => FavoriteDua(
    id: json['id'] as String,
    title: json['title'] as String,
    arabic: json['arabic'] as String,
    translation: json['translation'] as String,
    category: (json['category'] as String?) ?? '',
    reference: (json['reference'] as String?) ?? '',
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteDua &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
