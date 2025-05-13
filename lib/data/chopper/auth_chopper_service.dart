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
}
