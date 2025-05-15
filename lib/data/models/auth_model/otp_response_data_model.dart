import 'package:json_annotation/json_annotation.dart';

part 'otp_response_data_model.g.dart';

@JsonSerializable()
class OtpResponseDataModel {
  @JsonKey(
    name: 'mesage',
    readValue: _readMessageValue,
  ) // Maneja "mesage" o "message"
  final String? message;

  OtpResponseDataModel({this.message});

  factory OtpResponseDataModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$OtpResponseDataModelToJson(this);

  static Object? _readMessageValue(Map<dynamic, dynamic> json, String key) {
    return json['mesage'] ?? json['message'];
  }
}
