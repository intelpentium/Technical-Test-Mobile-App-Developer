import 'package:flutter/material.dart';

import '../cubit/player_state.dart';
import 'playback_slider.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    required this.state,
    required this.onPlayPause,
    required this.onSeek,
    required this.onStop,
    super.key,
  });

  final PlayerState state;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final selectedSurah = state.selectedSurah;
    final selectedAyah = state.selectedAyah;
    final canControl = state.hasAudio && !state.isLoading;
    final title = selectedSurah?.englishName ?? 'No recitation selected';
    final subtitle = selectedSurah == null
        ? 'Mishary Alafasy'
        : '${selectedSurah.reciterName} • Ayah ${selectedAyah?.numberInSurah ?? 1} preview';

    return Material(
      color: Colors.white,
      elevation: 10,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF4B5563)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (state.isLoading)
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  else
                    IconButton.filled(
                      tooltip: state.isPlaying ? 'Pause' : 'Play',
                      onPressed: canControl ? onPlayPause : null,
                      icon: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                  IconButton(
                    tooltip: 'Stop',
                    onPressed: canControl ? onStop : null,
                    icon: const Icon(Icons.stop),
                  ),
                ],
              ),
              PlaybackSlider(
                position: state.position,
                duration: state.duration,
                enabled: canControl && state.duration > Duration.zero,
                onSeek: onSeek,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
