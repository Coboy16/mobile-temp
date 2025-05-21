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

  @override
  Future<UserDetailsResponseModel> getUserDetails({
    required String userId,
  }) async {
    try {
      final response = await chopperService.getUserDetails(userId: userId);

      if (response.isSuccessful && response.body != null) {
        if (response.body!.status) {
          if (response.body!.userData != null) {
            return response.body!;
          } else {
            throw ServerException(
              message:
                  "Datos de usuario no encontrados a pesar de respuesta exitosa.",
              statusCode: response.statusCode,
            );
          }
        } else {
          String errorMessage = "Error al obtener detalles del usuario.";
          if (response.body!.data is Map &&
              (response.body!.data as Map).isEmpty) {
            errorMessage = "Usuario no encontrado o ID incorrecto.";
          } else if (response.body!.data is Map &&
              (response.body!.data as Map).containsKey('message')) {
            errorMessage = (response.body!.data as Map)['message'].toString();
          }
          throw ServerException(
            message: errorMessage,
            statusCode: response.body!.statusCode,
          );
        }
      } else {
        String errorMessage = "Error del servidor";
        int? statusCode = response.statusCode;

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
        throw ServerException(message: errorMessage, statusCode: statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
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
    try {
      final response = await chopperService.updateUserDetails(
        userId: userId,
        body: updateUserRequest,
      );

      if (response.body != null) {
        if (response.body!.status && response.body!.statusCode == 200) {
          return response.body!;
        } else {
          String errorMessage =
              response.body!.message ?? "Error al actualizar el usuario.";
          if (!response.body!.status &&
              response.body!.data != null &&
              response.body!.data!.isEmpty) {
            errorMessage =
                "Usuario no encontrado o ID incorrecto para actualizar.";
          }
          throw ServerException(
            message: errorMessage,
            statusCode: response.body!.statusCode,
          );
        }
      } else if (response.error != null) {
        String errorMessage = "Error del servidor al actualizar.";
        int? statusCode = response.statusCode;
        if (response.error is Map<String, dynamic>) {
          final errorMap = response.error as Map<String, dynamic>;
          if (errorMap.containsKey('message')) {
            errorMessage = errorMap['message'].toString();
          }
        } else if (response.error is String) {
          errorMessage = response.error.toString();
        }
        throw ServerException(message: errorMessage, statusCode: statusCode);
      } else {
        throw ServerException(
          message: "Respuesta inesperada del servidor al actualizar.",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message:
            'Error de comunicación al actualizar el usuario: ${e.toString()}',
      );
    }
  }

  @override
  Future<GeneralResponseModel> deleteUser({required String userId}) async {
    try {
      final response = await chopperService.deleteUser(userId: userId);

      if (response.body != null) {
        if (response.body!.status && response.body!.statusCode == 200) {
          return response.body!;
        } else {
          String errorMessage =
              response.body!.message ?? "Error al eliminar el usuario.";
          if (!response.body!.status &&
              response.body!.data != null &&
              response.body!.data!.isEmpty) {
            errorMessage =
                "Usuario no encontrado o ID incorrecto para eliminar.";
          }
          throw ServerException(
            message: errorMessage,
            statusCode: response.body!.statusCode,
          );
        }
      } else if (response.error != null) {
        String errorMessage = "Error del servidor al eliminar.";
        int? statusCode = response.statusCode;
        if (response.error is Map<String, dynamic>) {
          final errorMap = response.error as Map<String, dynamic>;
          if (errorMap.containsKey('message')) {
            errorMessage = errorMap['message'].toString();
          }
        } else if (response.error is String) {
          errorMessage = response.error.toString();
        }
        throw ServerException(message: errorMessage, statusCode: statusCode);
      } else {
        throw ServerException(
          message: "Respuesta inesperada del servidor al eliminar.",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message:
            'Error de comunicación al eliminar el usuario: ${e.toString()}',
      );
    }
  }
}
