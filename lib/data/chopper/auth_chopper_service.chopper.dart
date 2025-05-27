// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_chopper_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthChopperService extends AuthChopperService {
  _$AuthChopperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthChopperService;

  @override
  Future<Response<ValidationResponseModel>> validateUser({
    required ValidationRequestModel body,
  }) {
    final Uri $url = Uri.parse('/attemp/validation');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ValidationResponseModel, ValidationResponseModel>(
      $request,
    );
  }

  @override
  Future<Response<ValidationResponseModel>> checkUserLockStatus({
    required ValidationRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/attemp/validation');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ValidationResponseModel, ValidationResponseModel>(
      $request,
    );
  }

  @override
  Future<Response<LoginResponseModel>> login({
    required LoginRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/self/login');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<LoginResponseModel, LoginResponseModel>($request);
  }

  @override
  Future<Response<LoginResponseModel>> loginGoogle({
    required GoogleLoginRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/self/login-google');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<LoginResponseModel, LoginResponseModel>($request);
  }

  @override
  Future<Response<LogoutResponseModel>> logout({
    required LogoutRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/self/logout');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<LogoutResponseModel, LogoutResponseModel>($request);
  }

  @override
  Future<Response<RegisterResponseModel>> registerUser({
    required RegisterRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/user');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<RegisterResponseModel, RegisterResponseModel>($request);
  }

  @override
  Future<Response<RegisterResponseModel>> registerWithGoogle({
    required RegisterGoogleRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/user/gmail');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<RegisterResponseModel, RegisterResponseModel>($request);
  }

  @override
  Future<Response<OtpGeneralResponseModel>> requestOtp({
    required OtpRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/otp/request');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<OtpGeneralResponseModel, OtpGeneralResponseModel>(
      $request,
    );
  }

  @override
  Future<Response<OtpGeneralResponseModel>> verifyOtp({
    required OtpVerifyRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/otp/verify');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<OtpGeneralResponseModel, OtpGeneralResponseModel>(
      $request,
    );
  }

  @override
  Future<Response<ChangePasswordResponseModel>> changePassword({
    required ChangePasswordRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/self/forgot');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<ChangePasswordResponseModel, ChangePasswordResponseModel>(
          $request,
        );
  }

  @override
  Future<Response<UserDetailsResponseModel>> getUserDetails({
    required String userId,
  }) {
    final Uri $url = Uri.parse('/auth/user/${userId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<UserDetailsResponseModel, UserDetailsResponseModel>(
      $request,
    );
  }

  @override
  Future<Response<GeneralResponseModel>> updateUserDetails({
    required String userId,
    required UpdateUserRequestModel body,
  }) {
    final Uri $url = Uri.parse('/auth/user/${userId}');
    final $body = body;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<GeneralResponseModel, GeneralResponseModel>($request);
  }

  @override
  Future<Response<GeneralResponseModel>> deleteUser({required String userId}) {
    final Uri $url = Uri.parse('/auth/user/${userId}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<GeneralResponseModel, GeneralResponseModel>($request);
  }

  @override
  Future<Response<SessionStatusResponseModel>> checkSessionStatus({
    required String email,
  }) {
    final Uri $url = Uri.parse('/auth/session/${email}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<SessionStatusResponseModel, SessionStatusResponseModel>(
      $request,
    );
  }
}
