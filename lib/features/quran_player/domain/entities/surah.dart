import 'package:equatable/equatable.dart';

import '../../../../core/constants/api_constants.dart';

class Surah extends Equatable {
  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    this.reciterName = ApiConstants.defaultReciterName,
  });

  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;
  final String reciterName;

  bool matchesQuery(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return true;

    return [
      englishName,
      englishNameTranslation,
      name,
      reciterName,
    ].any((value) => value.toLowerCase().contains(query));
  }

  @override
  List<Object?> get props => [
    number,
    name,
    englishName,
    englishNameTranslation,
    numberOfAyahs,
    revelationType,
    reciterName,
  ];
}
