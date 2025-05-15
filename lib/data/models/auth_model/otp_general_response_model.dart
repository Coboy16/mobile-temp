import 'package:json_annotation/json_annotation.dart';
import 'otp_response_data_model.dart';

part 'otp_general_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OtpGeneralResponseModel {
  final int statusCode;
  final OtpResponseDataModel? data;
  final bool status;

  const OtpGeneralResponseModel({
    required this.statusCode,
    this.data,
    required this.status,
  });

  factory OtpGeneralResponseModel.fromJson(Map<String, dynamic> json) {
    dynamic dataField = json['data'];
    OtpResponseDataModel? parsedData;

    if (dataField is Map<String, dynamic>) {
      if (dataField.isEmpty) {
        parsedData = OtpResponseDataModel(message: null);
      } else {
        parsedData = OtpResponseDataModel.fromJson(dataField);
      }
    } else {
      parsedData = null;
    }

    return OtpGeneralResponseModel(
      statusCode: (json['statusCode'] as num).toInt(),
      data: parsedData,
      status: json['status'] as bool,
    );
  }

  Map<String, dynamic> toJson() => _$OtpGeneralResponseModelToJson(this);
}
