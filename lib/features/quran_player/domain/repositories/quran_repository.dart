import '../entities/ayah.dart';
import '../entities/surah.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahs();

  Future<List<Ayah>> getSurahAudio(int surahNumber);
}
