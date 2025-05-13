import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import '/data/data.dart';

class CustomJsonConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    final req = super.convertRequest(request);

    if (req.body == null || req.body is String || req.body is List<int>) {
      return req;
    }

    try {
      String jsonBody;
      final dynamic body = req.body;

      if (body is GoogleLoginRequestModel) {
        jsonBody = json.encode(body.toJson());
      } else if (body is LoginRequestModel) {
        jsonBody = json.encode(body.toJson());
      } else if (body is ValidationRequestModel) {
        jsonBody = json.encode(body.toJson());
      } else if (body is LogoutRequestModel) {
        jsonBody = json.encode(body.toJson());
      } else if (body is Map<String, dynamic>) {
        jsonBody = json.encode(body);
      } else {
        try {
          final toJsonMethod = body.toJson;
          if (toJsonMethod != null && toJsonMethod is Function) {
            jsonBody = json.encode(toJsonMethod());
          } else {
            jsonBody = json.encode(body);
          }
        } catch (e) {
          debugPrint(
            'CustomJsonConverter: Error dynamically serializing request body of type ${body.runtimeType}: $e. Returning original request.',
          );
          return req;
        }
      }
      return req.copyWith(
        body: jsonBody,
        headers: {...req.headers, 'Content-Type': 'application/json'},
      );
    } catch (e) {
      debugPrint(
        'CustomJsonConverter: Error converting request body to JSON: $e',
      );
      return req;
    }
  }

  @override
  Future<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response response,
  ) async {
    final Response dynamicResponse = await super.convertResponse(response);
    final body = dynamicResponse.body;

    if (body == null) {
      return dynamicResponse.copyWith(body: null);
    }

    if (body is! Map<String, dynamic>) {
      debugPrint(
        'CustomJsonConverter: Response body is not a Map<String, dynamic>. Actual type: ${body.runtimeType}. BodyType expected: $BodyType.',
      );
      try {
        return dynamicResponse.copyWith<BodyType>(body: body as BodyType);
      } catch (e) {
        debugPrint(
          'CustomJsonConverter: Error casting raw body to BodyType: $e. BodyType: $BodyType, Actual body type: ${body.runtimeType}',
        );
        rethrow;
      }
    }

    try {
      if (BodyType == LoginResponseModel) {
        final model = LoginResponseModel.fromJson(body);
        return dynamicResponse.copyWith<BodyType>(body: model as BodyType);
      } else if (BodyType == ValidationResponseModel) {
        final model = ValidationResponseModel.fromJson(body);
        return dynamicResponse.copyWith<BodyType>(body: model as BodyType);
      } else if (BodyType == LogoutResponseModel) {
        final model = LogoutResponseModel.fromJson(body);
        return dynamicResponse.copyWith<BodyType>(body: model as BodyType);
      }

      debugPrint(
        'CustomJsonConverter: BodyType $BodyType not explicitly handled for fromJson. Returning Map<String, dynamic> as BodyType.',
      );
      return dynamicResponse.copyWith<BodyType>(body: body as BodyType);
    } catch (e, stackTrace) {
      debugPrint(
        'CustomJsonConverter: Error during specific model fromJson conversion (BodyType: $BodyType): $e',
      );
      debugPrint('CustomJsonConverter - StackTrace: $stackTrace');
      chopperLogger.warning('Error converting response: $e');
      rethrow;
    }
  }
}
