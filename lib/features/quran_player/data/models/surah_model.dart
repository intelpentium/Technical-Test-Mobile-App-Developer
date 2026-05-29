import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.name,
    required super.englishName,
    required super.englishNameTranslation,
    required super.numberOfAyahs,
    required super.revelationType,
    super.reciterName,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: _readInt(json['number']),
      name: _readString(json['name']),
      englishName: _readString(json['englishName']),
      englishNameTranslation: _readString(json['englishNameTranslation']),
      numberOfAyahs: _readInt(json['numberOfAyahs']),
      revelationType: _readString(json['revelationType']),
    );
  }
}

int _readInt(Object? value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _readString(Object? value) => value?.toString() ?? '';
