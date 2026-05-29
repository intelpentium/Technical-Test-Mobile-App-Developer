class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ParsingException extends AppException {
  const ParsingException(super.message);
}

class AudioPlaybackException extends AppException {
  const AudioPlaybackException(super.message);
}
