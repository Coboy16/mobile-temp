// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) =>
    UserDataModel(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      fatherLastname: json['father_lastname'] as String,
      motherLastname: json['mother_lastname'] as String,
    );

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'father_lastname': instance.fatherLastname,
      'mother_lastname': instance.motherLastname,
    };
