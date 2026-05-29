import 'package:flutter_test/flutter_test.dart';
import 'package:quran_recitation_player/core/utils/duration_formatter.dart';

void main() {
  group('DurationFormatter', () {
    test('formats zero seconds', () {
      expect(DurationFormatter.format(Duration.zero), '00:00');
    });

    test('formats 65 seconds', () {
      expect(DurationFormatter.format(const Duration(seconds: 65)), '01:05');
    });

    test('formats one hour as minutes and seconds', () {
      expect(DurationFormatter.format(const Duration(hours: 1)), '60:00');
    });
  });
}
