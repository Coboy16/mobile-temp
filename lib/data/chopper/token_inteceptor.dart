import 'dart:async';

import 'package:chopper/chopper.dart';
import '/data/datasources/auth_remote_data/auth_local_data_source.dart';
import '/data/endpoint/api_endpoints.dart';

FutureOr<Request> Function(Request request) getTokenLogicInterceptor(
  AuthLocalDataSource localDataSource,
) {
  return (Request request) async {
    final noAuthPaths = [
      ApiEndpoints.login,
      ApiEndpoints.loginGoogle,
      ApiEndpoints.registerUser,
      ApiEndpoints.registerWithGoogle,
      ApiEndpoints.validateUser,
      ApiEndpoints.checkUserLockStatus,
      ApiEndpoints.otpRequest,
      ApiEndpoints.otpVerify,
      ApiEndpoints.changePassword,
    ];

    final requestPath = request.url.path;

    if (noAuthPaths.any((apiPath) => requestPath.endsWith(apiPath))) {
      return request;
    }

    final token = await localDataSource.getToken();
    if (token != null && token.isNotEmpty) {
      final headers = Map<String, String>.from(request.headers);
      headers['Authorization'] = 'Bearer $token';
      return request.copyWith(headers: headers);
    }
    return request;
  };
}
