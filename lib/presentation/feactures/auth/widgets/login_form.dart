import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '/presentation/resources/resources.dart';

class LoginForm extends StatefulWidget {
  final void Function()? onGoogleLogin;
  final void Function(String email, String passOrCedula)? onLogin;
  final VoidCallback onGoToRegister;
  final VoidCallback onGoToForgotPassword;

  const LoginForm({
    super.key,
    this.onGoogleLogin,
    this.onLogin,
    required this.onGoToRegister,
    required this.onGoToForgotPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;

  void _onLoginAttempt() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final username =
          _formKey.currentState?.fields['username']?.value as String;
      final password =
          _formKey.currentState?.fields['password']?.value as String;
      widget.onLogin?.call(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinar si es móvil basado en el ancho actual, si es necesario para espaciados internos
    final isMobile = MediaQuery.of(context).size.width <= 800;

    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormBuilderTextField(
            name: 'username',
            decoration: const InputDecoration(
              labelText: 'Usuario',
              hintText: 'Ingresa tu nombre de usuario',
              prefixIcon: Icon(LucideIcons.user),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: 'El usuario es requerido',
              ),
            ]),
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: isMobile ? 14 : AppDimensions.itemSpacing),
          FormBuilderTextField(
            name: 'password',
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
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
                6,
                errorText: 'La contraseña debe tener al menos 6 caracteres',
              ),
            ]),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _onLoginAttempt(),
          ),
          SizedBox(height: isMobile ? 0 : AppDimensions.itemSpacing / 2),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                padding:
                    isMobile ? const EdgeInsets.symmetric(vertical: 8.0) : null,
                overlayColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: widget.onGoToForgotPassword,
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
          SizedBox(height: isMobile ? 4 : AppDimensions.largeSpacing),
          ElevatedButton(
            onPressed: _onLoginAttempt,
            child: const Text('Iniciar Sesión'),
          ),
          SizedBox(height: isMobile ? 8 : AppDimensions.itemSpacing),
          if (widget.onGoogleLogin != null)
            OutlinedButton.icon(
              // Asegúrate que el asset exista
              icon: Image.asset(
                'assets/icons/google.png',
                width: 15,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(LucideIcons.chrome, size: 15),
              ),
              label: Text(
                'Iniciar Sesión con Google',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onPressed: widget.onGoogleLogin,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkTextColor,
                side: BorderSide(color: AppColors.borderColor),
              ),
            ),
          SizedBox(height: isMobile ? 10 : AppDimensions.itemSpacing / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿No tienes una cuenta? ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  overlayColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: widget.onGoToRegister,
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
