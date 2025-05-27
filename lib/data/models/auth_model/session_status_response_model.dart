import 'package:json_annotation/json_annotation.dart';

part 'session_status_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionStatusDataModel {
  final bool session;

  const SessionStatusDataModel({required this.session});

  factory SessionStatusDataModel.fromJson(Map<String, dynamic> json) =>
      _$SessionStatusDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionStatusDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SessionStatusResponseModel {
  final int statusCode;
  final SessionStatusDataModel data;
  final bool status;

  const SessionStatusResponseModel({
    required this.statusCode,
    required this.data,
    required this.status,
  });

  factory SessionStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SessionStatusResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionStatusResponseModelToJson(this);
}
