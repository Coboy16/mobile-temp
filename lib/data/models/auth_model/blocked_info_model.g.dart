// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedInfoModel _$BlockedInfoModelFromJson(Map<String, dynamic> json) =>
    BlockedInfoModel(
      state: json['state'] as bool,
      minute: (json['minute'] as num).toInt(),
    );

Map<String, dynamic> _$BlockedInfoModelToJson(BlockedInfoModel instance) =>
    <String, dynamic>{'state': instance.state, 'minute': instance.minute};
