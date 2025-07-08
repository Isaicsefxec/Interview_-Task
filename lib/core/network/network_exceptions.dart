class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  factory NetworkException.fromDioError(dynamic error) {
    if (error.response != null) {
      return NetworkException(
        'Error ${error.response?.statusCode}: ${error.response?.statusMessage}',
      );
    } else {
      return NetworkException(error.message ?? "Unknown network error");
    }
  }

  @override
  String toString() => message;
}
