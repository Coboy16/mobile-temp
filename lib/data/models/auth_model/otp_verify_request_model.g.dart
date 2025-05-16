// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerifyRequestModel _$OtpVerifyRequestModelFromJson(
  Map<String, dynamic> json,
) => OtpVerifyRequestModel(
  email: json['email'] as String,
  code: json['code'] as String,
  onlyVerify: json['onlyVerify'] as bool?,
);

Map<String, dynamic> _$OtpVerifyRequestModelToJson(
  OtpVerifyRequestModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  if (instance.onlyVerify case final value?) 'onlyVerify': value,
};
