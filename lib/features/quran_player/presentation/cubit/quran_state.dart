import 'package:equatable/equatable.dart';

import '../../domain/entities/surah.dart';

enum QuranStatus { initial, loading, loaded, error }

class QuranState extends Equatable {
  const QuranState({
    this.status = QuranStatus.initial,
    this.surahs = const [],
    this.filteredSurahs = const [],
    this.query = '',
    this.errorMessage,
  });

  final QuranStatus status;
  final List<Surah> surahs;
  final List<Surah> filteredSurahs;
  final String query;
  final String? errorMessage;

  QuranState copyWith({
    QuranStatus? status,
    List<Surah>? surahs,
    List<Surah>? filteredSurahs,
    String? query,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return QuranState(
      status: status ?? this.status,
      surahs: surahs ?? this.surahs,
      filteredSurahs: filteredSurahs ?? this.filteredSurahs,
      query: query ?? this.query,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    surahs,
    filteredSurahs,
    query,
    errorMessage,
  ];
}
