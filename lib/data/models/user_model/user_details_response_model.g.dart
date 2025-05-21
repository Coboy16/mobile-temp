// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailsResponseModel _$UserDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => UserDetailsResponseModel(
  statusCode: (json['statusCode'] as num).toInt(),
  data: json['data'],
  status: json['status'] as bool,
);

Map<String, dynamic> _$UserDetailsResponseModelToJson(
  UserDetailsResponseModel instance,
) => <String, dynamic>{
  'statusCode': instance.statusCode,
  'data': instance.data,
  'status': instance.status,
};
