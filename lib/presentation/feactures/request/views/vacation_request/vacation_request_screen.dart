import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '/data/data.dart';
import '/presentation/feactures/request/widgets/widget.dart';

class VacationRequestModal extends StatefulWidget {
  const VacationRequestModal({super.key});

  @override
  State<VacationRequestModal> createState() => _VacationRequestModalState();
}

class _VacationRequestModalState extends State<VacationRequestModal> {
  final _formKey = GlobalKey<FormBuilderState>();
  DateTime? _calculatedEndDate;

  // Nueva variable para manejar el empleado seleccionado fuera del FormBuilder
  Employee? _selectedEmployee;
  String? _employeeError;

  // Variables para validación manual de fecha de inicio y cantidad de días
  String? _startDateError;
  String? _numberOfDaysError;

  @override
  void initState() {
    super.initState();
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

    // Limpiar errores cuando el usuario cambie los valores
    setState(() {
      _startDateError = null;
      _numberOfDaysError = null;
    });
  }

  void _onEmployeeChanged(Employee? employee) {
    debugPrint('📝 VacationModal: Employee changed to: ${employee?.name}');
    setState(() {
      _selectedEmployee = employee;
      _employeeError = null; // Limpiar error cuando se selecciona empleado
    });
  }

  bool _validateEmployee() {
    if (_selectedEmployee == null) {
      setState(() {
        _employeeError = 'Debe seleccionar un empleado';
      });
      return false;
    }
    setState(() {
      _employeeError = null;
    });
    return true;
  }

  bool _validateDateAndDays() {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final fifteenDaysFromToday = todayMidnight.add(const Duration(days: 15));

    final startDate =
        _formKey.currentState?.fields['start_date']?.value as DateTime?;
    final numberOfDays =
        _formKey.currentState?.fields['number_of_days']?.value as int?;

    bool isValid = true;

    // Validar fecha de inicio
    if (startDate == null) {
      setState(() {
        _startDateError = '- La fecha de inicio es obligatoria';
      });
      isValid = false;
    } else if (startDate.isBefore(fifteenDaysFromToday)) {
      setState(() {
        _startDateError =
            'La solicitud debe ser con al menos 15 días de anticipación';
      });
      isValid = false;
    } else {
      setState(() {
        _startDateError = null;
      });
    }

    // Validar cantidad de días
    if (numberOfDays == null) {
      setState(() {
        _numberOfDaysError = '- Debe seleccionar la cantidad de días';
      });
      isValid = false;
    } else {
      setState(() {
        _numberOfDaysError = null;
      });
    }

    return isValid;
  }

  void _submitForm() {
    // Validar empleado primero
    final isEmployeeValid = _validateEmployee();

    // Validar fecha y días
    final isDateAndDaysValid = _validateDateAndDays();

    // Luego validar el formulario (solo el campo de motivo se validará automáticamente)
    final isFormValid = _formKey.currentState?.saveAndValidate() ?? false;

    if (isEmployeeValid && isDateAndDaysValid && isFormValid) {
      // Combinar datos del formulario con el empleado seleccionado
      final formData = _formKey.currentState?.value ?? {};
      final completeData = {...formData, 'employee': _selectedEmployee};

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solicitud enviada (simulación): ${completeData.toString()}',
          ),
        ),
      );
      Navigator.of(context).pop(completeData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<int> daysOptions = List.generate(15, (index) => index + 1);
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final fifteenDaysFromToday = todayMidnight.add(const Duration(days: 15));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Dialog(
        backgroundColor: Color(0xfff9f9fc),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 625, maxHeight: 830),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solicitud de Vacaciones',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Complete los detalles de su solicitud',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
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
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),

                      // EMPLEADO SELECTOR FUERA DEL FORMBUILDER
                      const FormSectionHeader(
                        title: 'Seleccionar Empleado',
                        isRequired: true,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EmployeeSelectorFormField(
                              name:
                                  'employee_standalone', // Nombre diferente ya que está fuera del form
                              onChanged: _onEmployeeChanged,
                              validator: (employee) {
                                if (employee == null) {
                                  return 'Debe seleccionar un empleado';
                                }
                                return null;
                              },
                            ),
                            // Mostrar error manualmente
                            if (_employeeError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  top: 8.0,
                                ),
                                child: Text(
                                  _employeeError!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // RESTO DEL FORMULARIO DENTRO DEL FORMBUILDER
                      FormBuilder(
                        key: _formKey,
                        // QUITAR autovalidateMode para evitar validación automática
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _validation(fifteenDaysFromToday, daysOptions),
                            const SizedBox(height: 8),

                            // Mostrar errores de validación manual ENCIMA del texto informativo
                            if (_startDateError != null ||
                                _numberOfDaysError != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_startDateError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: Text(
                                          _startDateError!,
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    if (_numberOfDaysError != null)
                                      Text(
                                        _numberOfDaysError!,
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.only(
                                top: 4.0,
                                left: 0.0,
                              ),
                              child: Text(
                                'La fecha de fin se calcula automáticamente basada en la fecha de inicio y la cantidad de días.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const FormSectionHeader(
                              title: 'Motivo de la solicitud',
                              isRequired: true,
                            ),
                            SizedBox(
                              height: 110,
                              child: FormBuilderTextField(
                                name: 'reason',
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText:
                                      'Describa el motivo de su solicitud',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 0.4,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: 'El motivo es obligatorio.',
                                  ),
                                  FormBuilderValidators.minLength(
                                    10,
                                    errorText:
                                        'El motivo debe tener al menos 10 caracteres.',
                                  ),
                                ]),
                                maxLength: 500,
                                // Remover onChanged para que no se valide automáticamente
                                // onChanged: (value) {
                                //   _formKey.currentState?.save();
                                // },
                              ),
                            ),
                            const FormSectionHeader(title: 'Adjunto documento'),
                            DocumentUploaderUniversal(
                              onFilesChanged: (files) {
                                debugPrint('Files selected: ${files.length}');
                              },
                              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                              maxFileSizeMB: 2,
                              maxFiles: 1,
                              allowMultiple: false,
                            ),
                            const SizedBox(height: 20),
                            const ImportantInfoBanner(),
                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.4,
                        ),
                        backgroundColor: Color(0xfff9f9fc),
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
                      onPressed: _submitForm,
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

  Widget _validation(DateTime fifteenDaysFromToday, List<int> daysOptions) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 205,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionHeader(
                title: 'Fecha de inicio',
                isRequired: true,
              ),
              InlineDatePickerField(
                name: 'start_date',
                hintText: 'Seleccionar fecha',
                calendarWidth: 240,
                firstDate: fifteenDaysFromToday,
                lastDate: DateTime(DateTime.now().year + 5),
                // QUITAR validators para evitar validación automática
                validators:
                    [], // Lista vacía en lugar de null para evitar errores
                onChanged: (value) {
                  _onDateOrDaysChanged();
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionHeader(title: 'Cant. días', isRequired: true),
              CustomDropdownField<int>(
                name: 'number_of_days',
                hintText: 'Seleccione',
                dropdownWidth: 150,
                maxVisibleItems: 5,
                items:
                    daysOptions
                        .map(
                          (days) => DropdownMenuItem(
                            value: days,
                            child: Text('$days día${days > 1 ? 's' : ''}'),
                          ),
                        )
                        .toList(),
                // QUITAR validators para evitar validación automática
                validators: [], // Lista vacía en lugar de null
                onChanged: (value) {
                  _onDateOrDaysChanged();
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 185,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionHeader(title: 'Fecha de fin calculada'),
              CalculatedEndDateDisplay(endDate: _calculatedEndDate),
            ],
          ),
        ),
      ],
    );
  }
}

class VacationRequestHelper {
  static Future<Map<String, dynamic>?> showVacationRequestModal(
    BuildContext context,
  ) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const VacationRequestModal();
      },
    );
  }
}
