import 'package:json_annotation/json_annotation.dart';

import '/domain/domain.dart';

part 'blocked_info_model.g.dart';

@JsonSerializable()
class BlockedInfoModel extends BlockedInfoEntity {
  const BlockedInfoModel({
    required super.state,
    // ignore: invalid_annotation_target
    @JsonKey(defaultValue: 0) required super.minute,
  });
  factory BlockedInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BlockedInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$BlockedInfoModelToJson(this);
}
