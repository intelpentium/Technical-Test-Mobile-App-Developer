import '../../domain/entities/ayah.dart';

class AyahModel extends Ayah {
  const AyahModel({
    required super.number,
    required super.numberInSurah,
    required super.text,
    super.audio,
    super.audioSecondary,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: _readInt(json['number']),
      numberInSurah: _readInt(json['numberInSurah']),
      text: _readString(json['text']),
      audio: _readNullableString(json['audio']),
      audioSecondary: _readStringList(json['audioSecondary']),
    );
  }
}

int _readInt(Object? value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _readString(Object? value) => value?.toString() ?? '';

String? _readNullableString(Object? value) {
  final stringValue = value?.toString().trim();
  if (stringValue == null || stringValue.isEmpty) return null;
  return stringValue;
}

List<String> _readStringList(Object? value) {
  if (value is! List) return const [];
  return value
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}
