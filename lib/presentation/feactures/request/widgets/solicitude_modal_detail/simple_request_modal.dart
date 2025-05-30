import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/feactures/request/mixins/mixins.dart';

import '/data/data.dart';

class SimpleRequestModal extends StatefulWidget {
  final SimpleRequestType requestType;
  final Function(SimpleRequestData)? onSubmit;

  const SimpleRequestModal({
    super.key,
    required this.requestType,
    this.onSubmit,
  });

  @override
  State<SimpleRequestModal> createState() => _SimpleRequestModalState();
}

class _SimpleRequestModalState extends State<SimpleRequestModal>
    with RequestValidationMixin {
  final _formKey = GlobalKey<FormBuilderState>();

  // Estado del formulario
  Employee? _selectedEmployee;
  List<UploadedFile> _attachedFiles = [];

  // Errores de validación
  String? _employeeError;
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

  void _onDateChanged() {
    _formKey.currentState?.save();
    setState(() {
      _dateError = null;
    });
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

  void _onFilesChanged(List<UploadedFile> files) {
    setState(() {
      _attachedFiles = files;
    });
    debugPrint('📁 Files changed: ${files.length}');
  }

  void _submitForm() {
    final isEmployeeValid = validateEmployee(_selectedEmployee, (error) {
      setState(() => _employeeError = error);
    });

    final isDateValid = _validateEffectiveDate();
    final isFormValid = _formKey.currentState?.saveAndValidate() ?? false;

    if (isEmployeeValid && isDateValid && isFormValid) {
      _processFormSubmission();
    }
  }

  bool _validateEffectiveDate() {
    final effectiveDate =
        _formKey.currentState?.fields['effective_date']?.value as DateTime?;

    if (effectiveDate == null) {
      setState(() {
        _dateError = 'La fecha es obligatoria';
      });
      return false;
    }

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowMidnight = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
    );

    if (effectiveDate.isBefore(tomorrowMidnight)) {
      setState(() {
        _dateError = 'La fecha debe ser desde mañana en adelante';
      });
      return false;
    }

    setState(() {
      _dateError = null;
    });
    return true;
  }

  void _processFormSubmission() {
    final formValues = _formKey.currentState?.value ?? {};

    final requestData = SimpleRequestData(
      employee: _selectedEmployee,
      effectiveDate: formValues['effective_date'] as DateTime?,
      reason: formValues['reason'] as String?,
      attachments: _attachedFiles,
      requestType: widget.requestType,
    );

    if (widget.onSubmit != null) {
      widget.onSubmit!(requestData);
    } else {
      _defaultSubmitBehavior(requestData);
    }
  }

  void _defaultSubmitBehavior(SimpleRequestData requestData) {
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        backgroundColor: const Color(0xfff9f9fc),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 625, maxHeight: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header reutilizado pero adaptado
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                            // Fecha de efectividad
                            SimpleEffectiveDateSection(
                              dateError: _dateError,
                              onDateChanged: _onDateChanged,
                              requestType: widget.requestType,
                            ),
                            const SizedBox(height: 16),

                            // Motivo
                            SimpleReasonSection(
                              requestType: widget.requestType,
                            ),

                            // Document uploader
                            DocumentUploaderUniversal(
                              onFilesChanged: (files) {
                                debugPrint('Files selected: ${files.length}');
                              },
                              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                              maxFileSizeMB: 5,
                              maxFiles: 1,
                              allowMultiple: false,
                            ),
                            const SizedBox(height: 20),

                            // Banner de información importante
                            SimpleImportantInfoBanner(
                              requestType: widget.requestType,
                            ),
                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer adaptado
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.requestType.title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.requestType.subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Cerrar',
            color: Colors.black87,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
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
              side: BorderSide(color: Colors.grey.shade300, width: 0.4),
              backgroundColor: const Color(0xfff9f9fc),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    );
  }
}
