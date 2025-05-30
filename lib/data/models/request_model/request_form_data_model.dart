import 'package:fe_core_vips/data/data.dart';

class RequestFormData {
  final Employee? employee;
  final DateTime? startDate;
  final int? numberOfDays;
  final String? reason;
  final String? medicalInfo;
  final MedicalLicenseType? medicalLicenseType;
  final List<String>? attachments;

  const RequestFormData({
    this.employee,
    this.startDate,
    this.numberOfDays,
    this.reason,
    this.medicalInfo,
    this.medicalLicenseType,
    this.attachments,
  });

  RequestFormData copyWith({
    Employee? employee,
    DateTime? startDate,
    int? numberOfDays,
    String? reason,
    String? medicalInfo,
    MedicalLicenseType? medicalLicenseType,
    List<String>? attachments,
  }) {
    return RequestFormData(
      employee: employee ?? this.employee,
      startDate: startDate ?? this.startDate,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      reason: reason ?? this.reason,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      medicalLicenseType: medicalLicenseType ?? this.medicalLicenseType,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employee': employee,
      'start_date': startDate,
      'number_of_days': numberOfDays,
      'reason': reason,
      if (medicalInfo != null) 'medical_info': medicalInfo,
      if (medicalLicenseType != null)
        'medical_license_type': medicalLicenseType?.displayName,
      'attachments': attachments,
    };
  }
}
