import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_recitation_player/features/quran_player/domain/entities/ayah.dart';
import 'package:quran_recitation_player/features/quran_player/domain/entities/surah.dart';
import 'package:quran_recitation_player/features/quran_player/presentation/cubit/player_state.dart';
import 'package:quran_recitation_player/features/quran_player/presentation/widgets/player_controls.dart';

void main() {
  testWidgets('shows play button when audio is paused', (tester) async {
    var toggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: PlayerControls(
            state: const PlayerState(
              status: PlayerStatus.paused,
              selectedSurah: Surah(
                number: 1,
                name: 'الفاتحة',
                englishName: 'Al-Faatiha',
                englishNameTranslation: 'The Opening',
                numberOfAyahs: 7,
                revelationType: 'Meccan',
              ),
              selectedAyah: Ayah(
                number: 1,
                numberInSurah: 1,
                text: '',
                audio: 'https://example.com/audio.mp3',
              ),
              duration: Duration(seconds: 65),
            ),
            onPlayPause: () => toggled = true,
            onSeek: (_) {},
            onStop: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.play_arrow), findsOneWidget);

    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    expect(toggled, isTrue);
  });
}
