import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculatedEndDateDisplay extends StatelessWidget {
  final DateTime? endDate;

  const CalculatedEndDateDisplay({super.key, this.endDate});

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (endDate != null) {
      final day = endDate!.day;
      final month = DateFormat('MMMM', 'es').format(endDate!);
      final year = endDate!.year.toString().substring(2);

      displayText = '$day de $month del 20$year';
    } else {
      displayText = 'Pendiente de cálculo';
    }

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
