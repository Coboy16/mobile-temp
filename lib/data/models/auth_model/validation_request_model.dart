import 'package:json_annotation/json_annotation.dart';

part 'validation_request_model.g.dart';

@JsonSerializable()
class ValidationRequestModel {
  final String email;

  ValidationRequestModel({required this.email});

  factory ValidationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ValidationRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ValidationRequestModelToJson(this);
}
