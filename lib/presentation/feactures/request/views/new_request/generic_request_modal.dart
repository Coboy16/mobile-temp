import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/feactures/request/mixins/mixins.dart';

import '/data/data.dart';

class GenericRequestModal extends StatefulWidget {
  final RequestType requestType;
  final Function(RequestFormData)? onSubmit;

  const GenericRequestModal({
    super.key,
    required this.requestType,
    this.onSubmit,
  });

  @override
  State<GenericRequestModal> createState() => _GenericRequestModalState();
}

class _GenericRequestModalState extends State<GenericRequestModal>
    with RequestValidationMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  // Estado del formulario
  DateTime? _calculatedEndDate;
  Employee? _selectedEmployee;
  List<UploadedFile> selectedFiles = [];

  // Errores de validación
  String? _employeeError;
  String? _startDateError;
  String? _numberOfDaysError;

  @override
  void initState() {
    super.initState();
    _initializeLocalization();
  }

  void _initializeLocalization() {
    initializeDateFormatting('es_ES', null);
    Intl.defaultLocale = 'es_ES';
  }

  void _updateCalculatedEndDate() {
    final startDate =
        _formKey.currentState?.fields['start_date']?.value as DateTime?;
    final numberOfDays =
        _formKey.currentState?.fields['number_of_days']?.value as int?;

    if (startDate != null && numberOfDays != null && numberOfDays > 0) {
      final newEndDate = startDate.add(Duration(days: numberOfDays - 1));
      if (_calculatedEndDate != newEndDate) {
        setState(() {
          _calculatedEndDate = newEndDate;
        });
      }
    } else {
      if (_calculatedEndDate != null) {
        setState(() {
          _calculatedEndDate = null;
        });
      }
    }
  }

  void _onDateOrDaysChanged() {
    _formKey.currentState?.save();
    _updateCalculatedEndDate();
    _clearDateAndDaysErrors();
  }

  void _onEmployeeChanged(Employee? employee) {
    debugPrint(
      '📝 ${widget.requestType.name}Modal: Employee changed to: ${employee?.name}',
    );
    setState(() {
      _selectedEmployee = employee;
      _employeeError = null;
    });
  }

  void _clearDateAndDaysErrors() {
    setState(() {
      _startDateError = null;
      _numberOfDaysError = null;
    });
  }

  void _submitForm() {
    final isEmployeeValid = validateEmployee(_selectedEmployee, (error) {
      setState(() => _employeeError = error);
    });

    final isDateAndDaysValid = validateDateAndDays(
      _formKey.currentState?.fields['start_date']?.value as DateTime?,
      _formKey.currentState?.fields['number_of_days']?.value as int?,
      (startError, daysError) {
        setState(() {
          _startDateError = startError;
          _numberOfDaysError = daysError;
        });
      },
    );

    final isFormValid = _formKey.currentState?.saveAndValidate() ?? false;

    if (isEmployeeValid && isDateAndDaysValid && isFormValid) {
      _processFormSubmission();
    }
  }

  void _processFormSubmission() {
    final formValues = _formKey.currentState?.value ?? {};

    final requestData = RequestFormData(
      employee: _selectedEmployee,
      startDate: formValues['start_date'] as DateTime?,
      numberOfDays: formValues['number_of_days'] as int?,
      reason: formValues['reason'] as String?,
      medicalInfo:
          widget.requestType.requiresMedicalInfo
              ? formValues['medical_info'] as String?
              : null,
      medicalLicenseType:
          widget.requestType.requiresMedicalInfo
              ? formValues['medical_license_type'] as MedicalLicenseType?
              : null,
    );

    if (widget.onSubmit != null) {
      widget.onSubmit!(requestData);
    } else {
      _defaultSubmitBehavior(requestData);
    }
  }

  void _defaultSubmitBehavior(RequestFormData requestData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Solicitud enviada (simulación): ${requestData.toMap().toString()}',
        ),
      ),
    );
    Navigator.of(context).pop(requestData.toMap());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        backgroundColor: const Color(0xfff9f9fc),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12.0 : 8.0),
        ),
        insetPadding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? screenWidth : 625,
            maxHeight: isMobile ? screenHeight * 0.95 : 830,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RequestModalHeader(
                requestType: widget.requestType,
                onClose: () => Navigator.of(context).pop(),
                isMobile: isMobile,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20.0 : 30.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      RequestEmployeeSection(
                        onEmployeeChanged: _onEmployeeChanged,
                        employeeError: _employeeError,
                      ),
                      const SizedBox(height: 10),
                      FormBuilder(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequestDatesSection(
                              calculatedEndDate: _calculatedEndDate,
                              startDateError: _startDateError,
                              numberOfDaysError: _numberOfDaysError,
                              onDateOrDaysChanged: _onDateOrDaysChanged,
                              showMedicalLicenseType:
                                  widget.requestType.requiresMedicalInfo,
                              isMobile: isMobile,
                            ),
                            const SizedBox(height: 5),
                            RequestReasonSection(
                              requestType: widget.requestType,
                            ),
                            const FormSectionHeader(title: 'Adjunto documento'),

                            DocumentUploaderUniversal(
                              onFilesChanged: (files) {
                                setState(() {
                                  selectedFiles = files;
                                });
                                debugPrint('Files selected: ${files.length}');
                              },
                              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                              maxFileSizeMB: 2,
                              maxFiles: 1,
                              allowMultiple: false,
                            ),
                            const SizedBox(height: 20),
                            const ImportantInfoBanner(),
                            SizedBox(height: isMobile ? 20 : 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RequestModalFooter(
                onCancel: () => Navigator.of(context).pop(),
                onSubmit: _submitForm,
                requestType: widget.requestType,
                isMobile: isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
