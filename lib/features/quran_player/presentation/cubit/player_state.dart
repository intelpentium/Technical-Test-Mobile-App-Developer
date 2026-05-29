import 'package:equatable/equatable.dart';

import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';

enum PlayerStatus { idle, loading, playing, paused, completed, error }

class PlayerState extends Equatable {
  const PlayerState({
    this.status = PlayerStatus.idle,
    this.selectedSurah,
    this.selectedAyah,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.errorMessage,
  });

  final PlayerStatus status;
  final Surah? selectedSurah;
  final Ayah? selectedAyah;
  final Duration position;
  final Duration duration;
  final String? errorMessage;

  bool get hasAudio => selectedSurah != null && selectedAyah != null;

  bool get isPlaying => status == PlayerStatus.playing;

  bool get isLoading => status == PlayerStatus.loading;

  PlayerState copyWith({
    PlayerStatus? status,
    Surah? selectedSurah,
    Ayah? selectedAyah,
    Duration? position,
    Duration? duration,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PlayerState(
      status: status ?? this.status,
      selectedSurah: selectedSurah ?? this.selectedSurah,
      selectedAyah: selectedAyah ?? this.selectedAyah,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedSurah,
    selectedAyah,
    position,
    duration,
    errorMessage,
  ];
}
