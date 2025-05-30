import 'package:chopper/chopper.dart' as chopper;

import '/core/errors/exceptions.dart';
import '/data/data.dart';

abstract class AuthRemoteDataSource {
  Future<ValidationResponseModel> validateUser({required String email});
  Future<ValidationResponseModel> checkUserLockStatus({required String email});
  Future<LoginResponseModel> login({
    required String email,
    required String cedulaOrPassword,
  });
  Future<LoginResponseModel> loginWithGoogle({
    required String idToken,
    required String email,
  });
  Future<LogoutResponseModel> logout({required String email});

  Future<ChangePasswordResponseModel> changePassword({
    // Nuevo método
    required String email,
    required String newPassword,
  });
  Future<SessionStatusResponseModel> checkSessionStatus({
    required String email,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthChopperService chopperService;

  AuthRemoteDataSourceImpl({required this.chopperService});

  Future<T> _handleChopperResponse<T>(
    Future<chopper.Response<T>> chopperCall,
  ) async {
    try {
      final response = await chopperCall;

      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        String errorMessage = "Error del servidor";
        int? statusCode = response.statusCode;
        dynamic errorBody = response.error;

        if (errorBody != null) {
          if (errorBody is Map<String, dynamic>) {
            if (errorBody.containsKey('message')) {
              errorMessage = errorBody['message'].toString();
            }
          } else if (errorBody is String) {
            errorMessage = errorBody;
          }
        } else if (response.base.reasonPhrase != null &&
            response.base.reasonPhrase!.isNotEmpty) {
          errorMessage = response.base.reasonPhrase!;
        }

        if (statusCode == 401 &&
            errorMessage.toLowerCase().contains("User not found")) {
          throw UnauthorizedException(
            message: errorMessage,
            statusCode: statusCode,
          );
        }
        throw ServerException(message: errorMessage, statusCode: statusCode);
      }
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Error de red o comunicación: ${e.toString()}',
      );
    }
  }

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String cedulaOrPassword,
  }) async {
    final requestModel = LoginRequestModel(
      email: email,
      cedulaOrPassword: cedulaOrPassword,
    );

    return _handleChopperResponse(chopperService.login(body: requestModel));
  }

  @override
  Future<ValidationResponseModel> validateUser({required String email}) async {
    final requestModel = ValidationRequestModel(email: email);

    try {
      final response = await chopperService.validateUser(body: requestModel);

      // Caso exitoso
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      }
      // Caso específico: Usuario bloqueado (401 con cuerpo válido)
      else if (response.statusCode == 401 && response.body != null) {
        return response.body!;
      }
      // Otros casos de error
      else {
        String errorMessage = "Error del servidor";
        int? statusCode = response.statusCode;

        if (response.error != null) {
          if (response.error is Map<String, dynamic>) {
            final errorMap = response.error as Map<String, dynamic>;
            if (errorMap.containsKey('message')) {
              errorMessage = errorMap['message'].toString();
            }
            // Caso especial de usuario bloqueado
            else if (errorMap.containsKey('data') &&
                errorMap['data'] is Map &&
                (errorMap['data'] as Map).containsKey('blocked')) {
              try {
                return ValidationResponseModel.fromJson(errorMap);
              } catch (e) {
                throw ServerException(
                  message: 'Error al procesar respuesta: ${e.toString()}',
                  statusCode: statusCode,
                );
              }
            }
          } else if (response.error is String) {
            errorMessage = response.error.toString();
          }
        } else if (response.base.reasonPhrase != null &&
            response.base.reasonPhrase!.isNotEmpty) {
          errorMessage = response.base.reasonPhrase!;
        }

        throw ServerException(message: errorMessage, statusCode: statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Error al validar usuario: ${e.toString()}',
      );
    }
  }

  @override
  Future<LoginResponseModel> loginWithGoogle({
    required String idToken,
    required String email,
  }) async {
    final requestModel = GoogleLoginRequestModel(
      idToken: idToken,
      email: email,
    );

    return _handleChopperResponse(
      chopperService.loginGoogle(body: requestModel),
    );
  }

  @override
  Future<LogoutResponseModel> logout({required String email}) async {
    final requestModel = LogoutRequestModel(email: email);

    try {
      final response = await chopperService.logout(body: requestModel);

      if (response.isSuccessful && response.body != null) {
        return response.body!; // response.body es LogoutResponseModel
      } else {
        String errorMessage = "Error del servidor al cerrar sesión";
        int? statusCode = response.statusCode;

        if (response.error != null) {
          if (response.error is LogoutResponseModel) {
            final errorBody = response.error as LogoutResponseModel;
            if (errorBody.data.containsKey('MESSAGES')) {
              errorMessage = errorBody.data['MESSAGES'].toString();
            } else if (errorBody.data.containsKey('message')) {
              errorMessage = errorBody.data['message'].toString();
            }
          } else if (response.error is Map<String, dynamic>) {
            final errorMap = response.error as Map<String, dynamic>;
            if (errorMap.containsKey('message')) {
              errorMessage = errorMap['message'].toString();
            } else if (errorMap.containsKey('data') &&
                errorMap['data'] is Map) {
              final dataMap = errorMap['data'] as Map<String, dynamic>;
              if (dataMap.containsKey('MESSAGES')) {
                // Coincide con tu log
                errorMessage = dataMap['MESSAGES'].toString();
              } else if (dataMap.containsKey('message')) {
                errorMessage = dataMap['message'].toString();
              }
            }
          } else if (response.error is String &&
              (response.error as String).isNotEmpty) {
            errorMessage = response.error.toString();
          }
        } else if (response.base.reasonPhrase != null &&
            response.base.reasonPhrase!.isNotEmpty) {
          errorMessage = response.base.reasonPhrase!;
        }
        throw ServerException(message: errorMessage, statusCode: statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Error de comunicación al cerrar sesión: ${e.toString()}',
      );
    }
  }

  @override
  Future<ValidationResponseModel> checkUserLockStatus({
    required String email,
  }) async {
    final requestModel = ValidationRequestModel(email: email);
    try {
      final response = await chopperService.checkUserLockStatus(
        body: requestModel,
      );

      if (response.body != null &&
          (response.isSuccessful ||
              response.statusCode == 400 ||
              response.statusCode == 401)) {
        return response.body!;
      } else {
        String errorMessage = "Error del servidor";
        int? statusCode = response.statusCode;

        if (response.error != null) {
          if (response.error is Map<String, dynamic>) {
            final errorMap = response.error as Map<String, dynamic>;
            if (errorMap.containsKey('data') &&
                errorMap['data'] is Map &&
                (errorMap['data'] as Map).containsKey('blocked')) {
              try {
                return ValidationResponseModel.fromJson(errorMap);
              } catch (e) {
                if (errorMap.containsKey('message')) {
                  errorMessage = errorMap['message'].toString();
                } else {
                  errorMessage =
                      'Error al procesar respuesta de error: ${e.toString()}';
                }
              }
            } else if (errorMap.containsKey('message')) {
              errorMessage = errorMap['message'].toString();
            }
          } else if (response.error is String) {
            errorMessage = response.error.toString();
          }
        } else if (response.base.reasonPhrase != null &&
            response.base.reasonPhrase!.isNotEmpty) {
          errorMessage = response.base.reasonPhrase!;
        }
        throw ServerException(message: errorMessage, statusCode: statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message:
            'Error al verificar estado de bloqueo del usuario: ${e.toString()}',
      );
    }
  }

  @override
  Future<ChangePasswordResponseModel> changePassword({
    required String email,
    required String newPassword,
  }) async {
    final requestModel = ChangePasswordRequestModel(
      email: email,
      password: newPassword,
    );
    return _handleChopperResponse(
      chopperService.changePassword(body: requestModel),
    );
  }

  @override
  Future<SessionStatusResponseModel> checkSessionStatus({
    required String email,
  }) async {
    return _handleChopperResponse<SessionStatusResponseModel>(
      chopperService.checkSessionStatus(email: email),
    );
  }
}
