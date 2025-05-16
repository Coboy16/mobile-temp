import 'package:chopper/chopper.dart' as chopper;
import '/core/errors/exceptions.dart';
import '/data/data.dart';

abstract class OtpRemoteDataSource {
  Future<OtpGeneralResponseModel> requestOtp({
    required String email,
    bool? onlyRequest,
  });
  Future<OtpGeneralResponseModel> verifyOtp({
    required String email,
    required String code,
    bool? onlyVerify,
  });
}

class OtpRemoteDataSourceImpl implements OtpRemoteDataSource {
  final AuthChopperService chopperService;

  OtpRemoteDataSourceImpl({required this.chopperService});

  Future<T> _handleOtpChopperResponse<T extends OtpGeneralResponseModel>(
    Future<chopper.Response<T>> chopperCall,
  ) async {
    try {
      final response = await chopperCall;

      if (response.body != null) {
        return response.body!;
      } else {
        String errorMessage = "Respuesta inesperada del servidor OTP";
        int? statusCode = response.statusCode;
        if (response.error != null) {
          if (response.error is Map<String, dynamic>) {
            final errorMap = response.error as Map<String, dynamic>;
            if (errorMap.containsKey('data') &&
                errorMap['data'] is Map<String, dynamic>) {
              final dataMap = errorMap['data'] as Map<String, dynamic>;
              if (dataMap.containsKey('message')) {
                errorMessage = dataMap['message'].toString();
              } else if (dataMap.containsKey('mesage')) {
                errorMessage = dataMap['mesage'].toString();
              }
            } else if (errorMap.containsKey('message')) {
              errorMessage = errorMap['message'].toString();
            }
          } else {
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
        message: 'Error de red o comunicación OTP: ${e.toString()}',
      );
    }
  }

  @override
  Future<OtpGeneralResponseModel> requestOtp({
    required String email,
    bool? onlyRequest,
  }) async {
    final requestModel = OtpRequestModel(
      email: email,
      onlyRequest: onlyRequest,
    );
    return _handleOtpChopperResponse(
      chopperService.requestOtp(body: requestModel),
    );
  }

  @override
  Future<OtpGeneralResponseModel> verifyOtp({
    required String email,
    required String code,
    bool? onlyVerify,
  }) async {
    final requestModel = OtpVerifyRequestModel(
      email: email,
      code: code,
      onlyVerify: onlyVerify,
    );
    return _handleOtpChopperResponse(
      chopperService.verifyOtp(body: requestModel),
    );
  }
}
