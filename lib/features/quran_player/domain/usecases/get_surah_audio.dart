import '../entities/ayah.dart';
import '../repositories/quran_repository.dart';

class GetSurahAudio {
  const GetSurahAudio(this._repository);

  final QuranRepository _repository;

  Future<List<Ayah>> call(int surahNumber) {
    return _repository.getSurahAudio(surahNumber);
  }
}
