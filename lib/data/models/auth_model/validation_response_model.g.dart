// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationResponseModel _$ValidationResponseModelFromJson(
  Map<String, dynamic> json,
) => ValidationResponseModel(
  data: ValidationResponseDataModel.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
  status: json['status'] as bool,
  statusCode: (json['statusCode'] as num).toInt(),
);

Map<String, dynamic> _$ValidationResponseModelToJson(
  ValidationResponseModel instance,
) => <String, dynamic>{
  'data': instance.data,
  'status': instance.status,
  'statusCode': instance.statusCode,
};
