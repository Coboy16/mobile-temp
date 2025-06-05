import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/feactures/request/mixins/mixins.dart';
import '/data/data.dart';

class HousingChangeRequestModal extends StatefulWidget {
  final Function(SimpleRequestData)? onSubmit;

  const HousingChangeRequestModal({super.key, this.onSubmit});

  @override
  State<HousingChangeRequestModal> createState() =>
      _HousingChangeRequestModalState();
}

class _HousingChangeRequestModalState extends State<HousingChangeRequestModal>
    with RequestValidationMixin {
  final _formKey = GlobalKey<FormBuilderState>();

  Employee? _selectedEmployee;
  List<UploadedFile> _attachedFiles = [];
  String? _employeeError;

  @override
  void initState() {
    super.initState();
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
    final isFormValid =
        _formKey.currentState?.saveAndValidate() ??
        false; // Valida solo el motivo

    if (isEmployeeValid && isFormValid) {
      _processFormSubmission();
    }
  }

  void _processFormSubmission() {
    final formValues = _formKey.currentState?.value ?? {};
    final requestData = SimpleRequestData(
      employee: _selectedEmployee,
      reason: formValues['reason'] as String?,
      attachments: _attachedFiles,
      requestType: SimpleRequestType.housingChange,
      // No se necesita: effectiveDate, letterType, addressee, exitType
    );
    widget.onSubmit?.call(requestData);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Usamos una constante para el tipo de solicitud para evitar errores de tipeo
    const SimpleRequestType currentRequestType =
        SimpleRequestType.housingChange;

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
                    ? screenHeight * 0.9
                    : 700, // Altura ajustada para menos campos
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabecera: Adaptar para usar SimpleRequestType
              Container(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 20.0 : 24.0,
                  isMobile ? 20.0 : 24.0,
                  isMobile ? 20.0 : 24.0,
                  16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentRequestType.title,
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentRequestType.subtitle,
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: isMobile ? 20 : 16),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Cerrar',
                      color: Colors.black87,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20.0 : 30.0,
                  ),
                  child: FormBuilder(
                    // Aunque solo hay un campo de texto, es útil para la validación y estructura
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
                        SimpleReasonSection(requestType: currentRequestType),
                        const SizedBox(height: 5),
                        const FormSectionHeader(title: 'Adjunto documento'),
                        DocumentUploaderUniversal(
                          onFilesChanged: _onFilesChanged,
                          maxFiles: 1,
                        ),
                        const SizedBox(height: 20),
                        SimpleImportantInfoBanner(
                          requestType: currentRequestType,
                        ),
                        SizedBox(height: isMobile ? 20 : 2),
                      ],
                    ),
                  ),
                ),
              ),
              // Pie de página: Adaptar para usar SimpleRequestType
              Container(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 20.0 : 24.0,
                  16.0,
                  isMobile ? 20.0 : 24.0,
                  isMobile ? 20.0 : 24.0,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.4,
                        ),
                        backgroundColor: const Color(0xfff9f9fc),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _validateAndSubmitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Enviar solicitud',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
