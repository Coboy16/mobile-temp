import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final String token;
  final int statusCode;
  @JsonKey(name: 'data')
  final UserModel user;
  final bool status;

  const LoginResponseModel({
    required this.token,
    required this.statusCode,
    required this.user,
    required this.status,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
