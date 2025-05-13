import 'package:json_annotation/json_annotation.dart';

part 'logout_request_model.g.dart';

@JsonSerializable()
class LogoutRequestModel {
  final String email;

  const LogoutRequestModel({required this.email});

  factory LogoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutRequestModelToJson(this);
}
