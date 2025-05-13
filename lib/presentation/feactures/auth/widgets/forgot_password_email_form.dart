import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/resources/resources.dart';

class ForgotPasswordEmailForm extends StatefulWidget {
  final Function(String email) onEmailSubmitted;
  final VoidCallback onGoToLogin;

  const ForgotPasswordEmailForm({
    super.key,
    // required this.isMobile,
    required this.onEmailSubmitted,
    required this.onGoToLogin,
  });

  @override
  State<ForgotPasswordEmailForm> createState() =>
      _ForgotPasswordEmailFormState();
}

class _ForgotPasswordEmailFormState extends State<ForgotPasswordEmailForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final email = _formKey.currentState?.value['email'] as String;
      widget.onEmailSubmitted(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 800;

    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormBuilderTextField(
            name: 'email',
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              hintText: 'Ingresa tu correo electrónico',
              prefixIcon: Icon(LucideIcons.mail),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'El correo es requerido',
              ),
              FormBuilderValidators.email(
                errorText: 'Ingresa un correo válido',
              ),
            ]),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitForm(),
          ),
          SizedBox(height: isMobile ? 20 : AppDimensions.largeSpacing * 1.2),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Enviar código de recuperación'),
          ),
          SizedBox(height: isMobile ? 12 : AppDimensions.itemSpacing),
          Center(
            child: TextButton(
              onPressed: widget.onGoToLogin,
              child: const Text('Volver a Iniciar Sesión'),
            ),
          ),
        ],
      ),
    );
  }
}
