import 'package:json_annotation/json_annotation.dart';

part 'login_google_request_model.g.dart';

@JsonSerializable()
class GoogleLoginRequestModel {
  final String idToken;
  final String email;

  GoogleLoginRequestModel({required this.idToken, required this.email});

  factory GoogleLoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleLoginRequestModelToJson(this);
}
