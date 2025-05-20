import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Para iconos

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/widgets.dart';

// Modelo simple (mantenido para este ejemplo, normalmente estaría en /models o similar)
class UserProfileData {
  final String firstName;
  final String? paternalLastName;
  final String? maternalLastName;
  final String email;

  UserProfileData({
    required this.firstName,
    this.paternalLastName,
    this.maternalLastName,
    required this.email,
  });
}

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Datos de ejemplo, vendrían de tu BLoC/repositorio
  final UserProfileData _userData = UserProfileData(
    firstName: "Elena",
    paternalLastName: "Valdés",
    // maternalLastName: "Ríos", // Ejemplo de campo vacío
    email: "elena.valdes@example.com",
  );

  void _onSaveChanges() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // Lógica para guardar cambios...
      // print('Datos a guardar: $formData');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cambios guardados con éxito',
            style: AppTextStyles.bodyText2.copyWith(color: AppColors.onPrimary),
          ),
          backgroundColor: AppColors.primaryVariant,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, corrige los errores.',
            style: AppTextStyles.bodyText2.copyWith(color: AppColors.onError),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _onDeleteAccount() async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Eliminar Cuenta',
      message:
          '¿Estás seguro? Esta acción es irreversible y todos tus datos serán eliminados.',
      okLabel: 'Sí, Eliminar',
      cancelLabel: 'Cancelar',
      isDestructiveAction: true,
      barrierDismissible: true,
    );
    if (result == OkCancelResult.ok) {
      // Lógica para eliminar la cuenta...
      // print("Solicitud de eliminación de cuenta...");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solicitud de eliminación de cuenta procesada (simulación)',
            style: AppTextStyles.bodyText2.copyWith(color: AppColors.onPrimary),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: AppTextStyles.headline2.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
      ),
      body: Center(
        child: MaxWidthBox(
          maxWidth: 800,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.0 : 24.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InitialsAvatar(
                  firstName: _userData.firstName,
                  lastName: _userData.paternalLastName,
                  radius: isMobile ? 45 : 55,
                  fontSize: isMobile ? 28 : 36,
                ),
                const SizedBox(height: 16.0),
                Text(
                  '${_userData.firstName} ${(_userData.paternalLastName ?? "")}',
                  style: AppTextStyles.headline1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  _userData.email,
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                _buildProfileForm(),
                const SizedBox(height: 32.0),
                _buildActionButtons(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          ProfileSectionContainer(
            title: 'Datos Personales',
            children: [
              CustomTextFormField(
                name: 'nombre',
                labelText: 'Nombre(s)*',
                initialValue: _userData.firstName,
                prefixIcon: const FaIcon(FontAwesomeIcons.user),
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'El nombre es requerido.',
                  ),
                ],
              ),
              CustomTextFormField(
                name: 'apellidoPaterno',
                labelText: 'Apellido Paterno',
                initialValue: _userData.paternalLastName,
                prefixIcon: const FaIcon(FontAwesomeIcons.userTag),
              ),
              CustomTextFormField(
                name: 'apellidoMaterno',
                labelText: 'Apellido Materno',
                initialValue: _userData.maternalLastName,
                prefixIcon: const FaIcon(FontAwesomeIcons.userTag),
              ),
            ],
          ),
          ProfileSectionContainer(
            title: 'Seguridad',
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.forbidden,
                child: CustomTextFormField(
                  name: 'correoElectronico',
                  labelText: 'Correo Electrónico',
                  initialValue: _userData.email,
                  readOnly: true, // Este campo no es editable
                  prefixIcon: const FaIcon(FontAwesomeIcons.solidEnvelope),
                ),
              ),
              CustomTextFormField(
                name: 'contrasena',
                labelText: 'Nueva Contraseña',
                hintText: 'Dejar en blanco para no cambiar',
                obscureText: true,
                prefixIcon: const FaIcon(FontAwesomeIcons.lock),
                validators: [
                  FormBuilderValidators.minLength(
                    8,
                    errorText: 'Mínimo 8 caracteres si se provee.',
                  ),
                  // Otros validadores si es necesario
                ],
                onChanged: (val) {
                  _formKey.currentState?.fields['confirmarContrasena']
                      ?.validate();
                },
              ),
              CustomTextFormField(
                name: 'confirmarContrasena',
                labelText: 'Confirmar Nueva Contraseña',
                hintText: 'Repetir contraseña',
                obscureText: true,
                prefixIcon: const FaIcon(FontAwesomeIcons.lock),
                validators: [
                  (val) {
                    final newPassword =
                        _formKey.currentState?.fields['contrasena']?.value;
                    if (newPassword != null &&
                        newPassword.isNotEmpty &&
                        val != newPassword) {
                      return 'Las contraseñas no coinciden.';
                    }
                    if (newPassword != null &&
                        newPassword.isNotEmpty &&
                        (val == null || val.isEmpty)) {
                      return 'Debes confirmar la contraseña.';
                    }
                    return null;
                  },
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    Widget saveButton = SizedBox(
      width: isMobile ? double.infinity : null,
      child: ElevatedButton.icon(
        icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk, size: 18),
        label: const Text('Guardar Cambios'),
        onPressed: _onSaveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );

    Widget deleteButton = SizedBox(
      width: isMobile ? double.infinity : null,
      child: TextButton.icon(
        icon: FaIcon(
          FontAwesomeIcons.trashCan,
          size: 16,
          color: AppColors.deleteButtonText,
        ),
        label: Text(
          'Eliminar Cuenta',
          style: AppTextStyles.button.copyWith(
            color: AppColors.deleteButtonText,
          ),
        ),
        onPressed: _onDeleteAccount,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: AppColors.deleteButtonBorder.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [saveButton, const SizedBox(height: 12), deleteButton],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [deleteButton, const SizedBox(width: 16), saveButton],
      );
    }
  }
}
