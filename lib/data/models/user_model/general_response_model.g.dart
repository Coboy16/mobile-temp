// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralResponseModel _$GeneralResponseModelFromJson(
  Map<String, dynamic> json,
) => GeneralResponseModel(
  statusCode: (json['statusCode'] as num).toInt(),
  data: json['data'] as Map<String, dynamic>?,
  status: json['status'] as bool,
);

Map<String, dynamic> _$GeneralResponseModelToJson(
  GeneralResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'data': instance.data,
  'status': instance.status,
};
