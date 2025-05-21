import 'package:chopper/chopper.dart';
import '/core/config/app_config.dart';
import '/data/data.dart';
import 'custom_json_converter.dart';

part 'auth_chopper_service.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class AuthChopperService extends ChopperService {
  static AuthChopperService create([ChopperClient? client]) {
    final defaultClient =
        client ??
        ChopperClient(
          baseUrl: Uri.parse(AppConfig.baseUrl),
          services: [_$AuthChopperService()],
          converter: CustomJsonConverter(),
          errorConverter: JsonConverter(),
          interceptors: [HttpLoggingInterceptor()],
        );
    return _$AuthChopperService(defaultClient);
  }

  @POST(path: ApiEndpoints.validateUser)
  Future<Response<ValidationResponseModel>> validateUser({
    @Body() required ValidationRequestModel body,
  });

  @POST(path: ApiEndpoints.checkUserLockStatus)
  Future<Response<ValidationResponseModel>> checkUserLockStatus({
    @Body() required ValidationRequestModel body,
  });

  @POST(path: ApiEndpoints.login)
  Future<Response<LoginResponseModel>> login({
    @Body() required LoginRequestModel body,
  });

  @POST(path: ApiEndpoints.loginGoogle)
  Future<Response<LoginResponseModel>> loginGoogle({
    @Body() required GoogleLoginRequestModel body,
  });

  @POST(path: ApiEndpoints.logout)
  Future<Response<LogoutResponseModel>> logout({
    @Body() required LogoutRequestModel body,
  });

  @POST(path: ApiEndpoints.registerUser)
  Future<Response<RegisterResponseModel>> registerUser({
    @Body() required RegisterRequestModel body,
  });

  @POST(path: ApiEndpoints.registerWithGoogle)
  Future<Response<RegisterResponseModel>> registerWithGoogle({
    @Body() required RegisterGoogleRequestModel body,
  });

  @POST(path: ApiEndpoints.otpRequest)
  Future<Response<OtpGeneralResponseModel>> requestOtp({
    @Body() required OtpRequestModel body,
  });

  @POST(path: ApiEndpoints.otpVerify)
  Future<Response<OtpGeneralResponseModel>> verifyOtp({
    @Body() required OtpVerifyRequestModel body,
  });

  @POST(path: ApiEndpoints.changePassword)
  Future<Response<ChangePasswordResponseModel>> changePassword({
    @Body() required ChangePasswordRequestModel body,
  });

  @GET(path: ApiEndpoints.getUserDetails)
  Future<Response<UserDetailsResponseModel>> getUserDetails({
    @Path('id') required String userId,
  });

  @PUT(path: ApiEndpoints.updateUserDetails)
  Future<Response<GeneralResponseModel>> updateUserDetails({
    @Path('id') required String userId,
    @Body() required UpdateUserRequestModel body,
  });

  @DELETE(path: ApiEndpoints.deleteUser)
  Future<Response<GeneralResponseModel>> deleteUser({
    @Path('id') required String userId,
  });
}
