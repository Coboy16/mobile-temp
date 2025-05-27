import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter/foundation.dart';
import '/core/errors/exceptions.dart';
import '/data/data.dart';

abstract class UserRemoteDataSource {
  Future<UserDetailsResponseModel> getUserDetails({required String userId});
  Future<GeneralResponseModel> updateUserDetails({
    required String userId,
    required UpdateUserRequestModel updateUserRequest,
  });
  Future<GeneralResponseModel> deleteUser({required String userId});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final AuthChopperService chopperService;

  UserRemoteDataSourceImpl({required this.chopperService});

  Future<T> _handleUserResponse<T>(
    Future<chopper.Response<T>> chopperCall,
  ) async {
    try {
      final response = await chopperCall;

      if (response.isSuccessful && response.body != null) {
        // Para UserDetailsResponseModel, verificamos el status interno también
        if (T == UserDetailsResponseModel) {
          final userDetailsResponse = response.body as UserDetailsResponseModel;
          if (userDetailsResponse.status &&
              userDetailsResponse.userData != null) {
            return response.body!;
          } else if (!userDetailsResponse.status &&
              userDetailsResponse.statusCode == 401 &&
              userDetailsResponse.data is Map &&
              (userDetailsResponse.data as Map).containsKey('message') &&
              (userDetailsResponse.data as Map)['message']
                      .toString()
                      .toLowerCase() ==
                  "User not found") {
            throw UnauthorizedException(
              message: (userDetailsResponse.data as Map)['message'],
              statusCode: userDetailsResponse.statusCode,
            );
          } else {
            String msg = "Error al obtener detalles del usuario.";
            if (userDetailsResponse.data is Map &&
                (userDetailsResponse.data as Map).isNotEmpty) {
              msg =
                  (userDetailsResponse.data as Map)['message']?.toString() ??
                  msg;
            }
            throw ServerException(
              message: msg,
              statusCode: userDetailsResponse.statusCode,
            );
          }
        }
        // Para GeneralResponseModel
        if (T == GeneralResponseModel) {
          final generalResponse = response.body as GeneralResponseModel;
          if (generalResponse.status && generalResponse.statusCode == 200) {
            return response.body!;
          } else if (!generalResponse.status &&
              generalResponse.statusCode == 401 &&
              generalResponse.data != null &&
              generalResponse.data!.containsKey('message') &&
              generalResponse.data!['message'].toString().toLowerCase() ==
                  "User not found") {
            throw UnauthorizedException(
              message: generalResponse.data!['message'],
              statusCode: generalResponse.statusCode,
            );
          } else {
            throw ServerException(
              message: generalResponse.message ?? "Error en la operación.",
              statusCode: generalResponse.statusCode,
            );
          }
        }
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
          // A veces el error 401 viene en el body de la respuesta aunque no sea successful
          else if (response.bodyString.contains(
                "\"message\": \"User not found\"",
              ) &&
              response.bodyString.contains("\"statusCode\": 401")) {
            throw UnauthorizedException(
              message: "User not found",
              statusCode: 401,
            );
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
  Future<UserDetailsResponseModel> getUserDetails({
    required String userId,
  }) async {
    try {
      final response = await chopperService.getUserDetails(
        userId: userId,
      ); // response es chopper.Response<UserDetailsResponseModel>

      // -------- LOG DETALLADO DE LA RESPUESTA DEL BACKEND (ASEGÚRATE QUE ESTÉ PRESENTE Y SE EJECUTE) --------

      if (response.error != null) {
        debugPrint(
          'USER_REMOTE_DATASOURCE - getUserDetails - Response Error (si existe): ${response.error}',
        );
      }

      if (response.body != null) {
        debugPrint(
          'USER_REMOTE_DATASOURCE - getUserDetails - Parsed Response Body (UserDetailsResponseModel): ${response.body!.toJson()}',
        );
      } else {
        debugPrint(
          'USER_REMOTE_DATASOURCE - getUserDetails - Response Body ES NULL.',
        );
      }
      // -------- FIN LOG DETALLADO --------

      if (response.isSuccessful && response.body != null) {
        if (response.body!.status) {
          // El backend dice que la operación fue exitosa en su lógica interna
          if (response.body!.userData != null) {
            // Y además nos dio los datos del usuario
            return response.body!; // Todo OK
          } else {
            // HTTP 200, status: true, PERO no hay userData. Extraño, pero posible.
            debugPrint(
              'USER_REMOTE_DATASOURCE - getUserDetails - CASO: HTTP 200, status: true, PERO userData ES NULL.',
            );
            throw ServerException(
              message:
                  "Datos de usuario no encontrados a pesar de respuesta exitosa y status true.", // Mensaje más específico
              statusCode: response.statusCode,
            );
          }
        } else {
          // El backend dice que la operación NO fue exitosa en su lógica interna (status: false)
          String errorMessage =
              "Error al obtener detalles del usuario (status:false desde backend)."; // Mensaje base
          // Intenta obtener un mensaje más específico del campo 'data' si es un mapa
          if (response.body!.data is Map) {
            final dataMap = response.body!.data as Map<String, dynamic>;
            if (dataMap.containsKey('message')) {
              errorMessage = dataMap['message'].toString();
            } else if (dataMap.isEmpty) {
              errorMessage =
                  "Usuario no encontrado o ID incorrecto (status:false, data vacía desde backend).";
            }
          }
          debugPrint(
            'USER_REMOTE_DATASOURCE - getUserDetails - CASO: HTTP 200, PERO status: false. Mensaje de error derivado: $errorMessage',
          );
          throw ServerException(
            message: errorMessage,
            statusCode: response.body!.statusCode,
          );
        }
      } else {
        // La respuesta HTTP no fue 2xx o el cuerpo es null
        String errorMessage =
            "Error del servidor (Respuesta HTTP no exitosa o cuerpo nulo)";
        int? finalStatusCode = response.statusCode;

        if (response.error != null) {
          if (response.error is Map<String, dynamic>) {
            final errorMap = response.error as Map<String, dynamic>;
            if (errorMap.containsKey('message')) {
              errorMessage = errorMap['message'].toString();
            }
          } else if (response.error is String) {
            errorMessage = response.error.toString();
          }
        } else if (response.base.reasonPhrase != null &&
            response.base.reasonPhrase!.isNotEmpty) {
          errorMessage = response.base.reasonPhrase!;
        }
        debugPrint(
          'USER_REMOTE_DATASOURCE - getUserDetails - CASO: Respuesta HTTP no exitosa o cuerpo nulo. Mensaje: $errorMessage, StatusCode: $finalStatusCode',
        );
        throw ServerException(
          message: errorMessage,
          statusCode: finalStatusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) {
        debugPrint(
          'USER_REMOTE_DATASOURCE - getUserDetails - Rethrowing ServerException: ${e.message}, statusCode: ${e.statusCode}',
        );
        rethrow;
      }

      throw ServerException(
        message:
            'Error de comunicación al obtener detalles del usuario: ${e.toString()}',
      );
    }
  }

  @override
  Future<GeneralResponseModel> updateUserDetails({
    required String userId,
    required UpdateUserRequestModel updateUserRequest,
  }) async {
    return _handleUserResponse(
      chopperService.updateUserDetails(userId: userId, body: updateUserRequest),
    );
  }

  @override
  Future<GeneralResponseModel> deleteUser({required String userId}) async {
    return _handleUserResponse(chopperService.deleteUser(userId: userId));
  }
}
