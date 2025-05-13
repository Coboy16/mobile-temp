import 'package:json_annotation/json_annotation.dart';

import 'blocked_info_model.dart';

part 'validation_response_data_model.g.dart';

@JsonSerializable()
class ValidationResponseDataModel {
  final BlockedInfoModel blocked;

  ValidationResponseDataModel({required this.blocked});

  factory ValidationResponseDataModel.fromJson(Map<String, dynamic> json) =>
      _$ValidationResponseDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ValidationResponseDataModelToJson(this);
}
