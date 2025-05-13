import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/resources/resources.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onGoToLogin;

  const RegisterForm({super.key, required this.onGoToLogin});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _onRegisterAttempt() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      debugPrint(
        'Formulario de registro válido: ${_formKey.currentState?.value}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrando usuario... (Simulado)')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa el formulario correctamente'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width <=
        800; // Si necesitas ajustar padding interno

    final InputDecoration baseDecoration = InputDecoration(
      prefixIconConstraints: const BoxConstraints(minWidth: 48),
      suffixIconConstraints: const BoxConstraints(minWidth: 48),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isMobile ? 12 : 16,
      ),
    );

    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormBuilderTextField(
            name: 'firstName',
            decoration: baseDecoration.copyWith(
              labelText: 'Nombres',
              hintText: 'Ingresa tus nombres',
              prefixIcon: const Icon(LucideIcons.user),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'Los nombres son requeridos',
              ),
            ]),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
          FormBuilderTextField(
            name: 'paternalLastName',
            decoration: baseDecoration.copyWith(
              labelText: 'Apellido Paterno',
              hintText: 'Ingresa tu apellido paterno',
              prefixIcon: const Icon(LucideIcons.userCheck),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'El apellido paterno es requerido',
              ),
            ]),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
          FormBuilderTextField(
            name: 'maternalLastName',
            decoration: baseDecoration.copyWith(
              labelText: 'Apellido Materno',
              hintText: 'Ingresa tu apellido materno',
              prefixIcon: const Icon(LucideIcons.userCheck),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'El apellido materno es requerido',
              ),
            ]),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
          FormBuilderTextField(
            name: 'email',
            decoration: baseDecoration.copyWith(
              labelText: 'Correo electrónico',
              hintText: 'Ingresa tu correo',
              prefixIcon: const Icon(LucideIcons.mail),
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
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
          FormBuilderTextField(
            name: 'password',
            obscureText: !_isPasswordVisible,
            decoration: baseDecoration.copyWith(
              labelText: 'Contraseña',
              hintText: 'Ingresa tu contraseña',
              prefixIcon: const Icon(LucideIcons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: AppColors.greyTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'La contraseña es requerida',
              ),
              FormBuilderValidators.minLength(
                8,
                errorText: 'Mínimo 8 caracteres',
              ),
              FormBuilderValidators.match(
                RegExp(r'^(?=.*[A-Z])'),
                errorText: 'Debe contener al menos una mayúscula',
              ),
              FormBuilderValidators.match(
                RegExp(r'^(?=.*\d)'),
                errorText: 'Debe contener al menos un número',
              ),
              FormBuilderValidators.match(
                RegExp(r'^(?=.*[!@#\$%^&*()_+={}\[\]:;<>,.?~\\-])'),
                errorText: 'Debe contener al menos un carácter especial',
              ),
            ]),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
          FormBuilderTextField(
            name: 'confirmPassword',
            obscureText: !_isConfirmPasswordVisible,
            decoration: baseDecoration.copyWith(
              labelText: 'Confirmar contraseña',
              hintText: 'Vuelve a ingresar tu contraseña',
              prefixIcon: const Icon(LucideIcons.lockKeyhole),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? LucideIcons.eyeOff
                      : LucideIcons.eye,
                  color: AppColors.greyTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'Confirma tu contraseña',
              ),
              (val) {
                if (_formKey.currentState?.fields['password']?.value != val) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ]),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _onRegisterAttempt(),
          ),
          SizedBox(height: isMobile ? 18 : AppDimensions.largeSpacing),
          ElevatedButton(
            onPressed: _onRegisterAttempt,
            child: const Text('Crear Cuenta'),
          ),
          SizedBox(height: isMobile ? 3 : AppDimensions.itemSpacing / 2),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¿Ya tienes una cuenta? ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: widget.onGoToLogin,
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
