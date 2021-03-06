import 'failures.dart';

class ServerException implements Exception {}

class CacheException implements Exception {}

class UnknownException implements Exception {
  const UnknownException(this.message);

  final String message;
}

class OfflineException implements Exception {}

T matchFailure<T>(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      throw ServerException();
    case CacheException:
      throw CacheException();
    default:
      throw UnknownException(failure.toString());
  }
}
