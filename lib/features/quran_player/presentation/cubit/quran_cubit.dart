import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_surahs.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(this._getSurahs) : super(const QuranState());

  final GetSurahs _getSurahs;

  Future<void> loadSurahs() async {
    emit(state.copyWith(status: QuranStatus.loading, clearErrorMessage: true));

    try {
      final surahs = await _getSurahs();
      emit(
        state.copyWith(
          status: QuranStatus.loaded,
          surahs: surahs,
          filteredSurahs: filterSurahs(surahs, state.query),
          clearErrorMessage: true,
        ),
      );
    } on AppException catch (error) {
      emit(
        state.copyWith(status: QuranStatus.error, errorMessage: error.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: QuranStatus.error,
          errorMessage: 'Failed to load Quran data. Please try again.',
        ),
      );
    }
  }

  void search(String query) {
    emit(
      state.copyWith(
        status: QuranStatus.loaded,
        query: query,
        filteredSurahs: filterSurahs(state.surahs, query),
        clearErrorMessage: true,
      ),
    );
  }

  static List<Surah> filterSurahs(List<Surah> surahs, String query) {
    return surahs
        .where((surah) => surah.matchesQuery(query))
        .toList(growable: false);
  }
}
