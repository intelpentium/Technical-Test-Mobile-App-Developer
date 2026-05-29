import '../../../../core/error/app_exception.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_remote_datasource.dart';

class QuranRepositoryImpl implements QuranRepository {
  const QuranRepositoryImpl({required QuranRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final QuranRemoteDataSource _remoteDataSource;

  @override
  Future<List<Surah>> getSurahs() async {
    try {
      return await _remoteDataSource.fetchSurahs();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const NetworkException(
        'Failed to load Quran data. Please try again.',
      );
    }
  }

  @override
  Future<List<Ayah>> getSurahAudio(int surahNumber) async {
    try {
      return await _remoteDataSource.fetchSurahAudio(surahNumber);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const NetworkException(
        'Failed to play audio. Please select another recitation.',
      );
    }
  }
}
