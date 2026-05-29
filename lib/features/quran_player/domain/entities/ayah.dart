import 'package:equatable/equatable.dart';

class Ayah extends Equatable {
  const Ayah({
    required this.number,
    required this.numberInSurah,
    required this.text,
    this.audio,
    this.audioSecondary = const [],
  });

  final int number;
  final int numberInSurah;
  final String text;
  final String? audio;
  final List<String> audioSecondary;

  String? get playableAudioUrl {
    final primaryAudio = audio?.trim();
    if (primaryAudio != null && primaryAudio.isNotEmpty) {
      return primaryAudio;
    }

    for (final secondaryAudio in audioSecondary) {
      final value = secondaryAudio.trim();
      if (value.isNotEmpty) return value;
    }

    return null;
  }

  @override
  List<Object?> get props => [
    number,
    numberInSurah,
    text,
    audio,
    audioSecondary,
  ];
}
