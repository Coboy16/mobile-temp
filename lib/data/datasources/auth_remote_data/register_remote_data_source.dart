import 'package:chopper/chopper.dart' as chopper;

import '/core/core.dart';
import '/data/data.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterResponseModel> registerUser({
    required String name,
    required String fatherLastname,
    required String motherLastname,
    required String email,
    required String password,
  });

  Future<RegisterResponseModel> registerWithGoogle({
    required String email,
    required String idToken,
  });
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final AuthChopperService chopperService; // Usamos el servicio existente

  RegisterRemoteDataSourceImpl({required this.chopperService});

  Future<T> _handleRegisterResponse<T extends RegisterResponseModel>(
    Future<chopper.Response<T>> chopperCall,
  ) async {
    try {
      final response = await chopperCall;

      if (response.body != null) {
        return response.body!;
      } else {
        String errorMessage = "Respuesta inesperada del servidor";
        int? statusCode = response.statusCode;
        if (response.error != null) {
          errorMessage = response.error.toString();
        } else if (response.base.reasonPhrase != null &&
            response.base.reasonPhrase!.isNotEmpty) {
          errorMessage = response.base.reasonPhrase!;
        }
        throw ServerException(message: errorMessage, statusCode: statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Error de red o comunicación: ${e.toString()}',
      );
    }
  }

  @override
  Future<RegisterResponseModel> registerUser({
    required String name,
    required String fatherLastname,
    required String motherLastname,
    required String email,
    required String password,
  }) async {
    final requestModel = RegisterRequestModel(
      name: name,
      fatherLastname: fatherLastname,
      motherLastname: motherLastname,
      email: email,
      password: password,
    );
    return _handleRegisterResponse(
      chopperService.registerUser(body: requestModel),
    );
  }

  @override
  Future<RegisterResponseModel> registerWithGoogle({
    required String email,
    required String idToken,
  }) async {
    final requestModel = RegisterGoogleRequestModel(
      email: email,
      idToken: idToken,
    );
    return _handleRegisterResponse(
      chopperService.registerWithGoogle(body: requestModel),
    );
  }
}
