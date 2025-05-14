// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_google_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterGoogleRequestModel _$RegisterGoogleRequestModelFromJson(
  Map<String, dynamic> json,
) => RegisterGoogleRequestModel(
  email: json['email'] as String,
  idToken: json['idToken'] as String,
);

Map<String, dynamic> _$RegisterGoogleRequestModelToJson(
  RegisterGoogleRequestModel instance,
) => <String, dynamic>{'email': instance.email, 'idToken': instance.idToken};
