import 'package:json_annotation/json_annotation.dart';
import 'user_data_model.dart';

part 'user_details_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDetailsResponseModel {
  final int statusCode;
  final dynamic data;
  final bool status;

  const UserDetailsResponseModel({
    required this.statusCode,
    required this.data,
    required this.status,
  });

  factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsResponseModelToJson(this);

  // Helper para obtener UserDataModel de forma segura
  UserDataModel? get userData {
    if (data is Map<String, dynamic> &&
        (data as Map<String, dynamic>).isNotEmpty) {
      try {
        return UserDataModel.fromJson(data as Map<String, dynamic>);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
