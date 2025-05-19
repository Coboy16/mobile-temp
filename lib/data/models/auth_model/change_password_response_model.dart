import 'package:json_annotation/json_annotation.dart';

part 'change_password_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChangePasswordResponseModel {
  final int statusCode;
  final Map<String, dynamic>? data;
  final bool status;

  const ChangePasswordResponseModel({
    required this.statusCode,
    this.data,
    required this.status,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChangePasswordResponseModelToJson(this);

  String? get message {
    if (data != null &&
        (data!.containsKey('message') || data!.containsKey('mesage'))) {
      return data!['message']?.toString() ?? data!['mesage']?.toString();
    }
    return null;
  }
}
