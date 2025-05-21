// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserRequestModel _$UpdateUserRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateUserRequestModel(
  name: json['name'] as String,
  fatherLastname: json['fatherLastname'] as String,
  motherLastname: json['motherLastname'] as String,
);

Map<String, dynamic> _$UpdateUserRequestModelToJson(
  UpdateUserRequestModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'fatherLastname': instance.fatherLastname,
  'motherLastname': instance.motherLastname,
};
