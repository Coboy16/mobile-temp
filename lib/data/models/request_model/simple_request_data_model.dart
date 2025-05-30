import '/data/data.dart';

class SimpleRequestData {
  final Employee? employee;
  final DateTime? effectiveDate;
  final String? reason;
  final List<UploadedFile>? attachments;
  final SimpleRequestType requestType;

  const SimpleRequestData({
    this.employee,
    this.effectiveDate,
    this.reason,
    this.attachments,
    required this.requestType,
  });

  SimpleRequestData copyWith({
    Employee? employee,
    DateTime? effectiveDate,
    String? reason,
    List<UploadedFile>? attachments,
    SimpleRequestType? requestType,
  }) {
    return SimpleRequestData(
      employee: employee ?? this.employee,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      reason: reason ?? this.reason,
      attachments: attachments ?? this.attachments,
      requestType: requestType ?? this.requestType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employee': employee,
      'effective_date': effectiveDate,
      'reason': reason,
      'attachments': attachments?.map((f) => f.name).toList(),
      'request_type': requestType.name,
    };
  }
}
