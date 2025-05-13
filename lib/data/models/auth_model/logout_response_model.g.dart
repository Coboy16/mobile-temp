// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogoutResponseModel _$LogoutResponseModelFromJson(Map<String, dynamic> json) =>
    LogoutResponseModel(
      statusCode: (json['statusCode'] as num).toInt(),
      data: json['data'] as Map<String, dynamic>,
      status: json['status'] as bool,
    );

Map<String, dynamic> _$LogoutResponseModelToJson(
  LogoutResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'data': instance.data,
  'status': instance.status,
};
