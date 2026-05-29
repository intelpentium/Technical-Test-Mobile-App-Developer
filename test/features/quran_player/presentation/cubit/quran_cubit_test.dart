import 'package:flutter_test/flutter_test.dart';
import 'package:quran_recitation_player/features/quran_player/domain/entities/surah.dart';
import 'package:quran_recitation_player/features/quran_player/presentation/cubit/quran_cubit.dart';

void main() {
  group('QuranCubit.filterSurahs', () {
    const surahs = [
      Surah(
        number: 1,
        name: 'الفاتحة',
        englishName: 'Al-Faatiha',
        englishNameTranslation: 'The Opening',
        numberOfAyahs: 7,
        revelationType: 'Meccan',
      ),
      Surah(
        number: 2,
        name: 'البقرة',
        englishName: 'Al-Baqara',
        englishNameTranslation: 'The Cow',
        numberOfAyahs: 286,
        revelationType: 'Medinan',
      ),
    ];

    test('returns all data when query is empty', () {
      expect(QuranCubit.filterSurahs(surahs, ''), surahs);
    });

    test('matches englishName', () {
      expect(QuranCubit.filterSurahs(surahs, 'baqara'), [surahs[1]]);
    });

    test('matches translation', () {
      expect(QuranCubit.filterSurahs(surahs, 'opening'), [surahs[0]]);
    });

    test('matches default reciter name', () {
      expect(QuranCubit.filterSurahs(surahs, 'alafasy'), surahs);
    });

    test('returns empty list when no item matches', () {
      expect(QuranCubit.filterSurahs(surahs, 'unknown'), isEmpty);
    });
  });
}
