import '/data/data.dart';

class SimpleRequestData {
  final Employee? employee;
  final DateTime? effectiveDate;
  final String? reason;
  final List<UploadedFile>? attachments;
  final SimpleRequestType requestType;
  final ExitType? exitType;
  final LetterType? letterType;
  final String? addressee;

  const SimpleRequestData({
    this.letterType,
    this.addressee,
    this.employee,
    this.effectiveDate,
    this.reason,
    this.attachments,
    this.exitType,
    required this.requestType,
  });

  SimpleRequestData copyWith({
    Employee? employee,
    DateTime? effectiveDate,
    String? reason,
    List<UploadedFile>? attachments,
    SimpleRequestType? requestType,
    ExitType? exitType,
    LetterType? letterType,
    String? addressee,
  }) {
    return SimpleRequestData(
      employee: employee ?? this.employee,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      reason: reason ?? this.reason,
      attachments: attachments ?? this.attachments,
      requestType: requestType ?? this.requestType,
      exitType: exitType ?? this.exitType,
      letterType: letterType ?? this.letterType,
      addressee: addressee ?? this.addressee,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employee': employee,
      'effective_date': effectiveDate,
      'reason': reason,
      'attachments': attachments?.map((f) => f.name).toList(),
      'request_type': requestType.name,
      'exitType': exitType?.name,
      'letter_type': letterType?.name,
      'addressee': addressee,
    };
  }
}
