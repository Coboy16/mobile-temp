// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordResponseModel _$ChangePasswordResponseModelFromJson(
  Map<String, dynamic> json,
) => ChangePasswordResponseModel(
  statusCode: (json['statusCode'] as num).toInt(),
  data: json['data'] as Map<String, dynamic>?,
  status: json['status'] as bool,
);

Map<String, dynamic> _$ChangePasswordResponseModelToJson(
  ChangePasswordResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'data': instance.data,
  'status': instance.status,
};
