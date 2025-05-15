import 'package:json_annotation/json_annotation.dart';

part 'otp_verify_request_model.g.dart';

@JsonSerializable()
class OtpVerifyRequestModel {
  final String email;
  final String code;

  OtpVerifyRequestModel({required this.email, required this.code});

  factory OtpVerifyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$OtpVerifyRequestModelToJson(this);
}
