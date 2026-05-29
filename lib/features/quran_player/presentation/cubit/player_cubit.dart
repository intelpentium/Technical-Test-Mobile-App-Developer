import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as audio;

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_surah_audio.dart';
import 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit(this._getSurahAudio, {audio.AudioPlayer? audioPlayer})
    : _audioPlayer = audioPlayer ?? audio.AudioPlayer(),
      super(const PlayerState()) {
    _positionSubscription = _audioPlayer.positionStream.listen(_onPosition);
    _durationSubscription = _audioPlayer.durationStream.listen(_onDuration);
    _playerStateSubscription = _audioPlayer.playerStateStream.listen(
      _onPlayerState,
    );
  }

  final GetSurahAudio _getSurahAudio;
  final audio.AudioPlayer _audioPlayer;

  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration?> _durationSubscription;
  late final StreamSubscription<audio.PlayerState> _playerStateSubscription;

  Future<void> selectSurah(Surah surah) async {
    if (state.selectedSurah?.number == surah.number && state.hasAudio) {
      await play();
      return;
    }

    emit(PlayerState(status: PlayerStatus.loading, selectedSurah: surah));

    try {
      await _audioPlayer.stop();
      final ayahs = await _getSurahAudio(surah.number);
      final ayah = _firstPlayableAyah(ayahs);
      final audioUrl = ayah?.playableAudioUrl;

      if (ayah == null || audioUrl == null) {
        throw const AudioPlaybackException(
          'Failed to play audio. Please select another recitation.',
        );
      }

      final duration = await _audioPlayer.setUrl(audioUrl);
      if (isClosed) return;

      emit(
        PlayerState(
          status: PlayerStatus.paused,
          selectedSurah: surah,
          selectedAyah: ayah,
          duration: duration ?? _audioPlayer.duration ?? Duration.zero,
        ),
      );

      await play();
    } on AppException catch (error) {
      _emitAudioError(surah, error.message);
    } catch (_) {
      _emitAudioError(
        surah,
        'Failed to play audio. Please select another recitation.',
      );
    }
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> play() async {
    if (!state.hasAudio || state.isLoading) return;

    try {
      if (state.status == PlayerStatus.completed) {
        await _audioPlayer.seek(Duration.zero);
      }
      await _audioPlayer.play();
    } catch (_) {
      _emitAudioError(
        state.selectedSurah,
        'Failed to play audio. Please select another recitation.',
      );
    }
  }

  Future<void> pause() async {
    if (!state.hasAudio || state.isLoading) return;

    await _audioPlayer.pause();
    if (!isClosed) {
      emit(state.copyWith(status: PlayerStatus.paused));
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    if (!isClosed) {
      emit(const PlayerState());
    }
  }

  Future<void> seek(Duration position) async {
    if (!state.hasAudio || state.duration == Duration.zero) return;

    final target = position > state.duration ? state.duration : position;
    await _audioPlayer.seek(target);
    if (!isClosed) {
      emit(state.copyWith(position: target));
    }
  }

  Ayah? _firstPlayableAyah(List<Ayah> ayahs) {
    for (final ayah in ayahs) {
      if (ayah.playableAudioUrl != null) return ayah;
    }
    return null;
  }

  void _onPosition(Duration position) {
    if (isClosed || !state.hasAudio) return;

    final cappedPosition = state.duration == Duration.zero
        ? position
        : position > state.duration
        ? state.duration
        : position;
    emit(state.copyWith(position: cappedPosition));
  }

  void _onDuration(Duration? duration) {
    if (isClosed || duration == null) return;
    emit(state.copyWith(duration: duration));
  }

  void _onPlayerState(audio.PlayerState playerState) {
    if (isClosed || !state.hasAudio || state.isLoading) return;

    if (playerState.processingState == audio.ProcessingState.completed) {
      emit(
        state.copyWith(
          status: PlayerStatus.completed,
          position: state.duration,
        ),
      );
      return;
    }

    if (playerState.playing) {
      emit(state.copyWith(status: PlayerStatus.playing));
      return;
    }

    if (state.status == PlayerStatus.playing) {
      emit(state.copyWith(status: PlayerStatus.paused));
    }
  }

  void _emitAudioError(Surah? surah, String message) {
    if (isClosed) return;
    emit(
      PlayerState(
        status: PlayerStatus.error,
        selectedSurah: surah,
        errorMessage: message,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _positionSubscription.cancel();
    await _durationSubscription.cancel();
    await _playerStateSubscription.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }
}
