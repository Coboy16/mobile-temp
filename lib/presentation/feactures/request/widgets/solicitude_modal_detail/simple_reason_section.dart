import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/data/data.dart';

class SimpleReasonSection extends StatelessWidget {
  final SimpleRequestType requestType;

  const SimpleReasonSection({super.key, required this.requestType});

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
          height: 110,
          child: FormBuilderTextField(
            name: 'reason',
            maxLines: 4,
            decoration: InputDecoration(
              hintText: requestType.reasonPlaceholder,
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
