// custom_json_converter.dart
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import '/data/data.dart';

class CustomJsonConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    final req = super.convertRequest(request);

    // Si el body es null o ya es una cadena, devuelve la request sin modificar
    if (req.body == null || req.body is String || req.body is List<int>) {
      return req;
    }

    try {
      String jsonBody;
      final dynamic body = req.body;

      // Verificar si es un Map
      if (body is Map<String, dynamic>) {
        jsonBody = json.encode(body);
      }
      // Verificar si es uno de nuestros modelos conocidos
      else if (body is GoogleLoginRequestModel) {
        jsonBody = json.encode(body.toJson());
      } else if (body is LoginRequestModel) {
        jsonBody = json.encode(body.toJson());
      } else if (body is ValidationRequestModel) {
        jsonBody = json.encode(body.toJson());
      }
      // Para otros objetos, intentar usar toJson si existe
      else {
        try {
          // Intenta llamar toJson() si el objeto lo tiene
          final toJsonMethod = body.toJson;
          if (toJsonMethod != null && toJsonMethod is Function) {
            jsonBody = json.encode(toJsonMethod());
          } else {
            jsonBody = json.encode(body);
          }
        } catch (_) {
          // Si falla, intentar serializar directamente
          jsonBody = json.encode(body);
        }
      }

      debugPrint('Converting request body to JSON: $jsonBody');

      return req.copyWith(
        body: jsonBody,
        headers: {...req.headers, 'Content-Type': 'application/json'},
      );
    } catch (e) {
      debugPrint('Error converting request body: $e');
      // En caso de error, devolver la request original
      return req;
    }
  }

  @override
  Future<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response response,
  ) async {
    final Response dynamicResponse = await super.convertResponse(response);

    debugPrint('Response status code: ${response.statusCode}');
    debugPrint('Response body: ${response.bodyString}');

    final body = dynamicResponse.body;
    if (body == null) {
      return dynamicResponse.copyWith(body: null);
    }

    try {
      if (BodyType == LoginResponseModel) {
        final model = LoginResponseModel.fromJson(body as Map<String, dynamic>);
        return dynamicResponse.copyWith<BodyType>(body: model as BodyType);
      } else if (BodyType == ValidationResponseModel) {
        final model = ValidationResponseModel.fromJson(
          body as Map<String, dynamic>,
        );
        return dynamicResponse.copyWith<BodyType>(body: model as BodyType);
      }
    } catch (e) {
      debugPrint('Error converting response: $e');
    }

    return dynamicResponse.copyWith<BodyType>(body: body);
  }
}
