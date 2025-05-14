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
}
