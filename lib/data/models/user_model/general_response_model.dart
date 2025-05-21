import 'package:json_annotation/json_annotation.dart';

part 'general_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GeneralResponseModel {
  final int statusCode;
  final Map<String, dynamic>? data; // Puede ser nulo o un mapa vacío
  final bool status;

  const GeneralResponseModel({
    required this.statusCode,
    this.data,
    required this.status,
  });

  factory GeneralResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GeneralResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralResponseModelToJson(this);

  String? get message {
    if (data != null && data!.containsKey('message')) {
      return data!['message']?.toString();
    }
    return null;
  }
}
