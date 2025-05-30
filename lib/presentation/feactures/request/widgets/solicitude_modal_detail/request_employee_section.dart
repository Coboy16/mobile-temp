import 'package:flutter/material.dart';
import '/data/data.dart';

import '/presentation/feactures/request/widgets/widget.dart';

class RequestEmployeeSection extends StatelessWidget {
  final Function(Employee?) onEmployeeChanged;
  final String? employeeError;

  const RequestEmployeeSection({
    super.key,
    required this.onEmployeeChanged,
    this.employeeError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                name: 'employee_standalone',
                onChanged: onEmployeeChanged,
                validator: (employee) {
                  if (employee == null) {
                    return 'Debe seleccionar un empleado';
                  }
                  return null;
                },
              ),
              if (employeeError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                  child: Text(
                    employeeError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
