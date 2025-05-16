// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequestModel _$OtpRequestModelFromJson(Map<String, dynamic> json) =>
    OtpRequestModel(
      email: json['email'] as String,
      onlyRequest: json['onlyRequest'] as bool?,
    );

Map<String, dynamic> _$OtpRequestModelToJson(OtpRequestModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      if (instance.onlyRequest case final value?) 'onlyRequest': value,
    };
