import 'package:json_annotation/json_annotation.dart';

part 'update_user_request_model.g.dart';

@JsonSerializable()
class UpdateUserRequestModel {
  final String name;
  @JsonKey(name: 'fatherLastname')
  final String fatherLastname;
  @JsonKey(name: 'motherLastname')
  final String motherLastname;

  const UpdateUserRequestModel({
    required this.name,
    required this.fatherLastname,
    required this.motherLastname,
  });

  factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestModelToJson(this);
}
