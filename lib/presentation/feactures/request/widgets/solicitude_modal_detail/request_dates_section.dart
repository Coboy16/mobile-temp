import 'package:flutter/material.dart';

import '/presentation/feactures/request/widgets/widget.dart';

class RequestDatesSection extends StatelessWidget {
  final DateTime? calculatedEndDate;
  final String? startDateError;
  final String? numberOfDaysError;
  final VoidCallback onDateOrDaysChanged;
  final bool showMedicalLicenseType;

  const RequestDatesSection({
    super.key,
    required this.calculatedEndDate,
    this.startDateError,
    this.numberOfDaysError,
    required this.onDateOrDaysChanged,
    this.showMedicalLicenseType = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> daysOptions = List.generate(15, (index) => index + 1);
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final fifteenDaysFromToday = todayMidnight.add(const Duration(days: 15));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStartDateField(fifteenDaysFromToday),
            const SizedBox(width: 16),
            _buildNumberOfDaysField(daysOptions),
            const SizedBox(width: 16),
            _buildCalculatedEndDateField(),
          ],
        ),
        const SizedBox(height: 8),
        _buildValidationErrors(context),
        _buildInformativeText(context),

        // NUEVO: Mostrar dropdown de tipo de licencia solo para licencia médica
        if (showMedicalLicenseType) ...[
          const SizedBox(height: 16),
          const MedicalLicenseTypeDropdown(),
        ],
      ],
    );
  }

  Widget _buildStartDateField(DateTime fifteenDaysFromToday) {
    return SizedBox(
      width: 205,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormSectionHeader(title: 'Fecha de inicio', isRequired: true),
          InlineDatePickerField(
            name: 'start_date',
            hintText: 'Seleccionar fecha',
            calendarWidth: 240,
            firstDate: fifteenDaysFromToday,
            lastDate: DateTime(DateTime.now().year + 5),
            validators: [],
            onChanged: (value) => onDateOrDaysChanged(),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberOfDaysField(List<int> daysOptions) {
    return SizedBox(
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
            validators: [],
            onChanged: (value) => onDateOrDaysChanged(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatedEndDateField() {
    return SizedBox(
      width: 185,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormSectionHeader(title: 'Fecha de fin calculada'),
          CalculatedEndDateDisplay(endDate: calculatedEndDate),
        ],
      ),
    );
  }

  Widget _buildValidationErrors(BuildContext context) {
    if (startDateError == null && numberOfDaysError == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (startDateError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                startDateError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          if (numberOfDaysError != null)
            Text(
              numberOfDaysError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInformativeText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 0.0),
      child: Text(
        'La fecha de fin se calcula automáticamente basada en la fecha de inicio y la cantidad de días.',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
      ),
    );
  }
}
