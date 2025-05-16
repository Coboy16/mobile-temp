import 'package:json_annotation/json_annotation.dart';

part 'otp_request_model.g.dart';

@JsonSerializable()
class OtpRequestModel {
  final String email;
  @JsonKey(name: 'onlyRequest', includeIfNull: false)
  final bool? onlyRequest;

  OtpRequestModel({required this.email, this.onlyRequest});

  factory OtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$OtpRequestModelToJson(this);
}
