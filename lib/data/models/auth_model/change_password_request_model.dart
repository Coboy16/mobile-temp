import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_model.g.dart';

@JsonSerializable()
class ChangePasswordRequestModel {
  final String email;
  final String password;

  ChangePasswordRequestModel({required this.email, required this.password});

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChangePasswordRequestModelToJson(this);
}
