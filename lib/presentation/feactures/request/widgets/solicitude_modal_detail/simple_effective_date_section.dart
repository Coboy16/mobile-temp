import 'package:flutter/material.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/data/data.dart';

class SimpleEffectiveDateSection extends StatelessWidget {
  final String? dateError;
  final VoidCallback onDateChanged;
  final SimpleRequestType requestType;

  const SimpleEffectiveDateSection({
    super.key,
    this.dateError,
    required this.onDateChanged,
    required this.requestType,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final tomorrow = todayMidnight.add(const Duration(days: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSectionHeader(
          title: requestType.effectiveDateLabel,
          isRequired: true,
        ),
        SizedBox(
          width: 300, // Ancho fijo como en la imagen
          child: InlineDatePickerField(
            name: 'effective_date',
            hintText: 'Seleccionar fecha',
            calendarWidth: 240,
            firstDate: tomorrow, // Desde mañana en adelante
            lastDate: DateTime(DateTime.now().year + 2),
            validators: [], // Sin validación automática
            onChanged: (value) => onDateChanged(),
          ),
        ),

        // Mostrar error si existe
        if (dateError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              dateError!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
