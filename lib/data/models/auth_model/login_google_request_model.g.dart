// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_google_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleLoginRequestModel _$GoogleLoginRequestModelFromJson(
  Map<String, dynamic> json,
) => GoogleLoginRequestModel(
  idToken: json['idToken'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$GoogleLoginRequestModelToJson(
  GoogleLoginRequestModel instance,
) => <String, dynamic>{'idToken': instance.idToken, 'email': instance.email};
