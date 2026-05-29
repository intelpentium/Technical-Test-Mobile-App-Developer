import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

abstract class QuranRemoteDataSource {
  Future<List<SurahModel>> fetchSurahs();

  Future<List<AyahModel>> fetchSurahAudio(int surahNumber);
}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  const QuranRemoteDataSourceImpl({required http.Client client})
    : _client = client;

  final http.Client _client;

  @override
  Future<List<SurahModel>> fetchSurahs() async {
    final response = await _client.get(ApiConstants.surahsUri());
    final data = _decodeResponse(response);

    if (data is! List) {
      throw const ParsingException('Invalid surah list response.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(SurahModel.fromJson)
        .toList(growable: false);
  }

  @override
  Future<List<AyahModel>> fetchSurahAudio(int surahNumber) async {
    final response = await _client.get(ApiConstants.surahAudioUri(surahNumber));
    final data = _decodeResponse(response);

    if (data is! Map<String, dynamic>) {
      throw const ParsingException('Invalid surah audio response.');
    }

    final ayahs = data['ayahs'];
    if (ayahs is! List) {
      throw const ParsingException('Invalid ayah audio response.');
    }

    return ayahs
        .whereType<Map<String, dynamic>>()
        .map(AyahModel.fromJson)
        .toList(growable: false);
  }

  Object? _decodeResponse(http.Response response) {
    final decodedBody = jsonDecode(response.body);
    if (decodedBody is! Map<String, dynamic>) {
      throw const ParsingException('Invalid API response.');
    }

    final apiCode = decodedBody['code'];
    if (response.statusCode != 200 || apiCode != 200) {
      throw const NetworkException(
        'Failed to load Quran data. Please try again.',
      );
    }

    return decodedBody['data'];
  }
}
