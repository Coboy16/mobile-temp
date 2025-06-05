// lib/presentation/feactures/request/widgets/solicitude_modal_detail/exit_request_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/feactures/request/mixins/mixins.dart';
import '/data/data.dart';

class ExitRequestModal extends StatefulWidget {
  final Function(SimpleRequestData)? onSubmit;

  const ExitRequestModal({super.key, this.onSubmit});

  @override
  State<ExitRequestModal> createState() => _ExitRequestModalState();
}

class _ExitRequestModalState extends State<ExitRequestModal>
    with RequestValidationMixin {
  final _formKey = GlobalKey<FormBuilderState>();

  Employee? _selectedEmployee;
  List<UploadedFile> _attachedFiles = [];
  ExitType? _selectedExitType;

  String? _employeeError;
  String? _exitTypeError;

  @override
  void initState() {
    super.initState();
    _initializeLocalization();
  }

  void _initializeLocalization() {
    initializeDateFormatting('es_ES', null);
    Intl.defaultLocale = 'es_ES';
  }

  void _onEmployeeChanged(Employee? employee) {
    setState(() {
      _selectedEmployee = employee;
      _employeeError = null;
    });
  }

  void _onFilesChanged(List<UploadedFile> files) {
    setState(() => _attachedFiles = files);
  }

  void _validateAndSubmitForm() {
    final isEmployeeValid = validateEmployee(_selectedEmployee, (error) {
      setState(() => _employeeError = error);
    });

    bool isExitTypeValid = true;
    if (_selectedExitType == null) {
      setState(() => _exitTypeError = 'Debe seleccionar un tipo de salida.');
      isExitTypeValid = false;
    } else {
      setState(() => _exitTypeError = null);
    }

    bool isDateValid = true;
    final exitDate =
        _formKey.currentState?.fields['effective_date']?.value
            as DateTime?; // Reutilizamos 'effective_date' para la fecha de salida
    if (exitDate == null) {
      isDateValid = false;
    } else {
      // Puedes añadir validaciones de fecha si es necesario, por ejemplo, no puede ser en el pasado.
      // Por ahora, solo verificamos que no sea nula.
      // final today = DateTime.now();
      // if (exitDate.isBefore(DateTime(today.year, today.month, today.day))) {
      //   setState(() => _dateError = 'La fecha de salida no puede ser en el pasado.');
      //   isDateValid = false;
      // } else {
      // }
    }

    final isFormValid = _formKey.currentState?.saveAndValidate() ?? false;

    if (isEmployeeValid && isExitTypeValid && isDateValid && isFormValid) {
      _processFormSubmission();
    }
  }

  void _processFormSubmission() {
    final formValues = _formKey.currentState?.value ?? {};
    final requestData = SimpleRequestData(
      employee: _selectedEmployee,
      exitType: _selectedExitType,
      effectiveDate:
          formValues['effective_date'] as DateTime?, // Fecha de salida
      reason: formValues['reason'] as String?,
      attachments: _attachedFiles,
      requestType: SimpleRequestType.exit,
    );
    widget.onSubmit?.call(requestData);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const requestType = SimpleRequestType.exit;

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
                requestType: RequestType.values.firstWhere(
                  (rt) => rt.name == requestType.name,
                  orElse: () => RequestType.exitRequest,
                ),
                onClose: () => Navigator.of(context).pop(),
                isMobile: isMobile,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20.0 : 30.0,
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        RequestEmployeeSection(
                          onEmployeeChanged: _onEmployeeChanged,
                          employeeError: _employeeError,
                        ),
                        const SizedBox(height: 16),

                        // Tipo de Salida
                        const FormSectionHeader(
                          title: 'Tipo de Salida',
                          isRequired: true,
                        ),
                        CustomDropdownField<ExitType>(
                          name: 'exit_type_dropdown',
                          hintText: 'Seleccione el tipo de salida',
                          items:
                              ExitType.values
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type.displayName),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedExitType = value;
                              _exitTypeError = null;
                            });
                          },
                        ),
                        if (_exitTypeError != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              top: 8.0,
                            ),
                            child: Text(
                              _exitTypeError!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Fecha de Salida (usando SimpleEffectiveDateSection)
                        // SimpleEffectiveDateSection(
                        //   // El label se tomará de requestType.effectiveDateLabel
                        //   dateError: _dateError,
                        //   onDateChanged: _onDateChanged,
                        //   requestType: requestType, // Pasa el tipo correcto
                        // ),
                        const SizedBox(height: 16),

                        SimpleReasonSection(requestType: requestType),
                        const SizedBox(height: 5),

                        const FormSectionHeader(title: 'Adjunto documento'),
                        DocumentUploaderUniversal(
                          onFilesChanged: _onFilesChanged,
                          maxFiles: 1,
                        ),
                        const SizedBox(height: 20),
                        SimpleImportantInfoBanner(requestType: requestType),
                        SizedBox(height: isMobile ? 20 : 2),
                      ],
                    ),
                  ),
                ),
              ),
              RequestModalFooter(
                onCancel: () => Navigator.of(context).pop(),
                onSubmit: _validateAndSubmitForm,
                requestType: RequestType.values.firstWhere(
                  (rt) => rt.name == requestType.name,
                  orElse: () => RequestType.exitRequest,
                ),
                isMobile: isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
