import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/data/data.dart';

class RequestReasonSection extends StatelessWidget {
  final RequestType requestType;

  const RequestReasonSection({super.key, required this.requestType});

  String get _hintText {
    switch (requestType) {
      case RequestType.vacation:
        return 'Describa el motivo de su solicitud de vacaciones';
      case RequestType.permission:
        return 'Describa el motivo de su solicitud de permiso';
      case RequestType.medicalLeave:
        return 'Describa el motivo de su licencia médica';
      case RequestType.suspension:
        return 'Describa el motivo de su solicitud de suspensión';
      case RequestType.letter:
        return 'Describa el motivo de su solicitud de cartas';
      case RequestType.accommodationChange:
        return 'Describa el motivo de su solicitud de cambio de alojamiento';
      case RequestType.exitRequest:
        return 'Describa el motivo de su solicitud de salida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionHeader(
          title: 'Motivo de la solicitud',
          isRequired: true,
        ),
        SizedBox(
          height: 180,
          child: FormBuilderTextField(
            name: 'reason',
            maxLines: 4,
            decoration: InputDecoration(
              hintText: _hintText,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 0.4),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'El motivo es obligatorio.',
              ),
              FormBuilderValidators.minLength(
                10,
                errorText: 'El motivo debe tener al menos 10 caracteres.',
              ),
            ]),
            maxLength: 500,
          ),
        ),
      ],
    );
  }
}
