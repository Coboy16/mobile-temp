import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/presentation/feactures/perfil/utils/app_colors.dart';
import '/presentation/feactures/perfil/utils/app_text_styles.dart';

import 'custom_text_form_field_widget.dart';
import 'profile_section_container_widget.dart';

class SecuritySettingsCard extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final String email;
  final VoidCallback onSaveChangesPassword;

  const SecuritySettingsCard({
    super.key,
    required this.formKey,
    required this.email,
    required this.onSaveChangesPassword,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      title: 'Seguridad',
      titleCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correo Electrónico (No editable)',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: FaIcon(
                            FontAwesomeIcons.solidEnvelope,
                            size: 18,
                            color: AppColors.icon.withOpacity(0.8),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            email,
                            style: AppTextStyles.bodyText1.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                name: 'contrasenaActual',
                labelText: 'Contraseña Actual',
                hintText: 'Ingresa tu contraseña actual',
                obscureText: true,
                prefixIcon: const FaIcon(FontAwesomeIcons.key),
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'La contraseña actual es requerida.',
                  ),
                ],
              ),
              CustomTextFormField(
                name: 'contrasenaNueva',
                labelText: 'Nueva Contraseña',
                hintText: 'Mínimo 8 caracteres',
                obscureText: true,
                prefixIcon: const FaIcon(FontAwesomeIcons.lock),
                validators: [
                  (val) {
                    if (val != null && val.isNotEmpty && val.length < 8) {
                      return 'Mínimo 8 caracteres.';
                    }
                    final confirmPassword =
                        formKey
                                .currentState
                                ?.fields['confirmarContrasena']
                                ?.value
                            as String?;
                    if ((confirmPassword != null &&
                            confirmPassword.isNotEmpty) &&
                        (val == null || val.isEmpty)) {
                      return 'Ingresa la nueva contraseña.';
                    }
                    return null;
                  },
                ],
                onChanged: (val) {
                  formKey.currentState?.fields['confirmarContrasena']
                      ?.validate();
                },
              ),
              CustomTextFormField(
                name: 'confirmarContrasena',
                labelText: 'Confirmar Nueva Contraseña',
                hintText: 'Repetir nueva contraseña',
                obscureText: true,
                prefixIcon: const FaIcon(FontAwesomeIcons.lock),
                validators: [
                  (val) {
                    final newPassword =
                        formKey.currentState?.fields['contrasenaNueva']?.value
                            as String?;
                    if (newPassword != null && newPassword.isNotEmpty) {
                      if (val == null || val.isEmpty) {
                        return 'Debes confirmar la nueva contraseña.';
                      }
                      if (val != newPassword) {
                        return 'Las nuevas contraseñas no coinciden.';
                      }
                    } else if (val != null && val.isNotEmpty) {
                      return 'Ingresa primero la nueva contraseña.';
                    }
                    return null;
                  },
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 18),
                  label: const Text('Actualizar Contraseña'),
                  onPressed: onSaveChangesPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: AppTextStyles.button.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
