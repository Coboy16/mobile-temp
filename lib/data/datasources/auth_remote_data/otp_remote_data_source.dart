import 'package:chopper/chopper.dart' as chopper;
import '/core/errors/exceptions.dart';
import '/data/data.dart';

abstract class OtpRemoteDataSource {
  Future<OtpGeneralResponseModel> requestOtp({required String email});
  Future<OtpGeneralResponseModel> verifyOtp({
    required String email,
    required String code,
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
        message: 'Error de red o comunicación OTP: ${e.toString()}',
      );
    }
  }

  @override
  Future<OtpGeneralResponseModel> requestOtp({required String email}) async {
    final requestModel = OtpRequestModel(email: email);
    return _handleOtpChopperResponse(
      chopperService.requestOtp(body: requestModel),
    );
  }

  @override
  Future<OtpGeneralResponseModel> verifyOtp({
    required String email,
    required String code,
  }) async {
    final requestModel = OtpVerifyRequestModel(email: email, code: code);
    return _handleOtpChopperResponse(
      chopperService.verifyOtp(body: requestModel),
    );
  }
}
