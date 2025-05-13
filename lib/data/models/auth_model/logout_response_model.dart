import 'package:json_annotation/json_annotation.dart';

part 'logout_response_model.g.dart';

@JsonSerializable()
class LogoutResponseModel {
  final int statusCode;
  @JsonKey(name: 'data')
  final Map<String, dynamic> data;
  final bool status;

  const LogoutResponseModel({
    required this.statusCode,
    required this.data,
    required this.status,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutResponseModelToJson(this);
}
