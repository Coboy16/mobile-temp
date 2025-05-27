// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_general_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpGeneralResponseModel _$OtpGeneralResponseModelFromJson(
  Map<String, dynamic> json,
) => OtpGeneralResponseModel(
  statusCode: (json['statusCode'] as num).toInt(),
  data:
      json['data'] == null
          ? null
          : OtpResponseDataModel.fromJson(json['data'] as Map<String, dynamic>),
  status: json['status'] as bool,
);

Map<String, dynamic> _$OtpGeneralResponseModelToJson(
  OtpGeneralResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'data': instance.data?.toJson(),
  'status': instance.status,
};
