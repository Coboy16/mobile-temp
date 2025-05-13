// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_response_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationResponseDataModel _$ValidationResponseDataModelFromJson(
  Map<String, dynamic> json,
) => ValidationResponseDataModel(
  blocked: BlockedInfoModel.fromJson(json['blocked'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ValidationResponseDataModelToJson(
  ValidationResponseDataModel instance,
) => <String, dynamic>{'blocked': instance.blocked};
