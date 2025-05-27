// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_status_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionStatusDataModel _$SessionStatusDataModelFromJson(
  Map<String, dynamic> json,
) => SessionStatusDataModel(session: json['session'] as bool);

Map<String, dynamic> _$SessionStatusDataModelToJson(
  SessionStatusDataModel instance,
) => <String, dynamic>{'session': instance.session};

SessionStatusResponseModel _$SessionStatusResponseModelFromJson(
  Map<String, dynamic> json,
) => SessionStatusResponseModel(
  statusCode: (json['statusCode'] as num).toInt(),
  data: SessionStatusDataModel.fromJson(json['data'] as Map<String, dynamic>),
  status: json['status'] as bool,
);

Map<String, dynamic> _$SessionStatusResponseModelToJson(
  SessionStatusResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'data': instance.data.toJson(),
  'status': instance.status,
};
