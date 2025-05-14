import 'package:json_annotation/json_annotation.dart';

part 'register_google_request_model.g.dart';

@JsonSerializable()
class RegisterGoogleRequestModel {
  final String email;
  final String idToken;

  RegisterGoogleRequestModel({required this.email, required this.idToken});

  factory RegisterGoogleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterGoogleRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterGoogleRequestModelToJson(this);
}
