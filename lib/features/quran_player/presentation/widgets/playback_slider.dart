import 'package:flutter/material.dart';

import '../../../../core/utils/duration_formatter.dart';

class PlaybackSlider extends StatefulWidget {
  const PlaybackSlider({
    required this.position,
    required this.duration,
    required this.enabled,
    required this.onSeek,
    super.key,
  });

  final Duration position;
  final Duration duration;
  final bool enabled;
  final ValueChanged<Duration> onSeek;

  @override
  State<PlaybackSlider> createState() => _PlaybackSliderState();
}

class _PlaybackSliderState extends State<PlaybackSlider> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final durationMs = widget.duration.inMilliseconds;
    final maxValue = durationMs > 0 ? durationMs.toDouble() : 1.0;
    final positionMs = widget.position.inMilliseconds
        .clamp(0, durationMs > 0 ? durationMs : 1)
        .toDouble();
    final sliderValue = (_dragValue ?? positionMs).clamp(0.0, maxValue);
    final displayPosition = Duration(milliseconds: sliderValue.round());

    return Column(
      children: [
        Slider(
          value: sliderValue,
          min: 0,
          max: maxValue,
          onChanged: widget.enabled
              ? (value) => setState(() => _dragValue = value)
              : null,
          onChangeEnd: widget.enabled
              ? (value) {
                  setState(() => _dragValue = null);
                  widget.onSeek(Duration(milliseconds: value.round()));
                }
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DurationFormatter.format(displayPosition)),
              Text(DurationFormatter.format(widget.duration)),
            ],
          ),
        ),
      ],
    );
  }
}
