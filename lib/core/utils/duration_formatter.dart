class DurationFormatter {
  const DurationFormatter._();

  static String format(Duration? duration) {
    final totalSeconds = (duration ?? Duration.zero).inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
