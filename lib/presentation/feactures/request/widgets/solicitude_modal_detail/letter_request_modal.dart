import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/feactures/request/mixins/mixins.dart';
import '/data/data.dart';

class LetterRequestModal extends StatefulWidget {
  final Function(SimpleRequestData)? onSubmit;

  const LetterRequestModal({super.key, this.onSubmit});

  @override
  State<LetterRequestModal> createState() => _LetterRequestModalState();
}

class _LetterRequestModalState extends State<LetterRequestModal>
    with RequestValidationMixin {
  final _formKey = GlobalKey<FormBuilderState>();

  Employee? _selectedEmployee;
  LetterType? _selectedLetterType;
  List<UploadedFile> _attachedFiles = [];

  String? _employeeError;
  String? _letterTypeError;
  String? _dateError;

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

  void _onDateChanged() {
    _formKey.currentState?.save(); // Guarda los valores actuales del formulario
    setState(() => _dateError = null); // Limpia el error de fecha al cambiarla
  }

  void _validateAndSubmitForm() {
    final isEmployeeValid = validateEmployee(_selectedEmployee, (error) {
      setState(() => _employeeError = error);
    });

    bool isLetterTypeValid = true;
    if (_selectedLetterType == null) {
      setState(() => _letterTypeError = 'Debe seleccionar un tipo de carta.');
      isLetterTypeValid = false;
    } else {
      setState(() => _letterTypeError = null);
    }

    bool isDateValid = true;
    // Validar fecha de efectividad (reutilizada de SimpleEffectiveDateSection)
    final effectiveDate =
        _formKey.currentState?.fields['effective_date']?.value as DateTime?;
    if (effectiveDate == null) {
      setState(() => _dateError = 'La fecha de efectividad es obligatoria.');
      isDateValid = false;
    } else {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowMidnight = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
      );
      if (effectiveDate.isBefore(tomorrowMidnight)) {
        setState(
          () => _dateError = 'La fecha debe ser desde mañana en adelante.',
        );
        isDateValid = false;
      } else {
        setState(() => _dateError = null);
      }
    }

    final isFormValid =
        _formKey.currentState?.saveAndValidate() ??
        false; // Valida 'addressee' y 'reason'

    if (isEmployeeValid && isLetterTypeValid && isDateValid && isFormValid) {
      _processFormSubmission();
    }
  }

  void _processFormSubmission() {
    final formValues = _formKey.currentState?.value ?? {};
    final requestData = SimpleRequestData(
      employee: _selectedEmployee,
      letterType: _selectedLetterType,
      addressee: formValues['addressee'] as String?,
      effectiveDate: formValues['effective_date'] as DateTime?,
      reason: formValues['reason'] as String?,
      attachments: _attachedFiles,
      requestType: SimpleRequestType.letter,
    );
    widget.onSubmit?.call(requestData);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const requestType = SimpleRequestType.letter;

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
            maxHeight:
                isMobile
                    ? screenHeight * 0.95
                    : 830, // Ajustado para más campos
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RequestModalHeader(
                requestType: RequestType.values.firstWhere(
                  (rt) => rt.name == requestType.name,
                  orElse: () => RequestType.letter,
                ), // Adaptar o crear nuevo enum
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
                        const SizedBox(height: 5),

                        // Tipo de Carta
                        const FormSectionHeader(
                          title: 'Tipo de Carta',
                          isRequired: true,
                        ),
                        CompactDropdownField<LetterType>(
                          name: 'letter_type_dropdown',
                          hintText: 'Seleccione el tipo de carta',
                          items:
                              LetterType.values
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type.displayName),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLetterType = value;
                              _letterTypeError = null;
                            });
                          },
                        ),
                        if (_letterTypeError != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              top: 8.0,
                            ),
                            child: Text(
                              _letterTypeError!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 5),

                        // Destinatario
                        const FormSectionHeader(
                          title: 'Destinatario',
                          isRequired: true,
                        ),
                        FormBuilderTextField(
                          name: 'addressee',
                          decoration: InputDecoration(
                            hintText:
                                'Nombre de la persona o institución destinataria',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'El destinatario es obligatorio.',
                            ),
                          ]),
                        ),

                        // Fecha de Efectividad
                        SimpleEffectiveDateSection(
                          dateError: _dateError,
                          onDateChanged: _onDateChanged,
                          requestType: requestType,
                        ),
                        const SizedBox(height: 5),

                        SimpleReasonSection(requestType: requestType),
                        const SizedBox(height: 5),

                        const FormSectionHeader(title: 'Adjunto documento'),
                        DocumentUploaderUniversal(
                          onFilesChanged: _onFilesChanged,
                          maxFiles: 1, // O permitir más si es necesario
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
                // Adaptar esto si RequestType no tiene 'letter'
                requestType: RequestType.values.firstWhere(
                  (rt) => rt.name == requestType.name,
                  orElse: () => RequestType.letter,
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
