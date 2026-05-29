class ApiConstants {
  const ApiConstants._();

  static const baseUrl = 'https://api.alquran.cloud/v1';
  static const audioEdition = 'ar.alafasy';
  static const defaultReciterName = 'Mishary Alafasy';

  static Uri surahsUri() => Uri.parse('$baseUrl/surah');

  static Uri surahAudioUri(int surahNumber) {
    return Uri.parse('$baseUrl/surah/$surahNumber/$audioEdition');
  }
}
