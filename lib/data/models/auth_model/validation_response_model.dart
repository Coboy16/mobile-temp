import 'package:json_annotation/json_annotation.dart';

import 'validation_response_data_model.dart';

part 'validation_response_model.g.dart';

@JsonSerializable()
class ValidationResponseModel {
  final ValidationResponseDataModel data;
  final bool status;
  final int statusCode;

  const ValidationResponseModel({
    required this.data,
    required this.status,
    required this.statusCode,
  });

  factory ValidationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ValidationResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ValidationResponseModelToJson(this);
}
