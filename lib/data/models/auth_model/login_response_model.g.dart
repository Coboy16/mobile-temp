// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      token: json['token'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      user: UserModel.fromJson(json['data'] as Map<String, dynamic>),
      status: json['status'] as bool,
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'statusCode': instance.statusCode,
      'data': instance.user,
      'status': instance.status,
    };
