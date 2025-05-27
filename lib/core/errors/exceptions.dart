class ServerException implements Exception {
  final String? message;
  final int? statusCode;
  ServerException({this.message, this.statusCode});
}

class CacheException implements Exception {
  final String? message;
  CacheException({this.message});
}

class UnauthorizedException extends ServerException {
  UnauthorizedException({String? message, super.statusCode = 401})
    : super(message: message ?? "User not found");
}
