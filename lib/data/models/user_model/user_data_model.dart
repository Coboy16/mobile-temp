import 'package:json_annotation/json_annotation.dart';
import '/domain/domain.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserDataModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String email;
  final String name;
  @JsonKey(name: 'father_lastname')
  final String? fatherLastname;
  @JsonKey(name: 'mother_lastname')
  final String? motherLastname;

  const UserDataModel({
    required this.userId,
    required this.email,
    required this.name,
    this.fatherLastname,
    this.motherLastname,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);

  UserDetailsEntity toEntity() {
    return UserDetailsEntity(
      userId: userId,
      email: email,
      name: name,
      fatherLastname: fatherLastname ?? "",
      motherLastname: motherLastname ?? "",
    );
  }
}
