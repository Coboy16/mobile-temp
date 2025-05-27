import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/resources/resources.dart';
import 'custom_text_form_field_widget.dart';
import 'profile_section_container_widget.dart';

class SecuritySettingsCard extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final String email;
  final VoidCallback onSaveChangesPassword;
  final bool isChangingPassword;

  const SecuritySettingsCard({
    super.key,
    required this.formKey,
    required this.email,
    required this.onSaveChangesPassword,
    this.isChangingPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      title: 'Cambiar Contraseña',
      titleCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Para cambiar tu contraseña, ingresa la nueva contraseña y confírmala.',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              CustomTextFormField(
                name: 'contrasenaNueva',
                labelText: 'Nueva Contraseña',
                hintText: 'Mínimo 8 caracteres',
                obscureText: true,
                showPasswordToggle: true, // ← AGREGADO
                prefixIcon: const Icon(LucideIcons.lock),
                readOnly: isChangingPassword,
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
                  if (!isChangingPassword) {
                    formKey.currentState?.fields['confirmarContrasena']
                        ?.validate();
                  }
                },
              ),
              CustomTextFormField(
                name: 'confirmarContrasena',
                labelText: 'Confirmar Nueva Contraseña',
                hintText: 'Repetir nueva contraseña',
                obscureText: true,
                showPasswordToggle: true, // ← AGREGADO
                prefixIcon: const Icon(LucideIcons.lock),
                readOnly: isChangingPassword,
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
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon:
                      isChangingPassword
                          ? Container()
                          : const Icon(LucideIcons.refreshCcw, size: 18),
                  label:
                      isChangingPassword
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.onPrimary,
                              ),
                            ),
                          )
                          : const Text('Actualizar Contraseña'),
                  onPressed: isChangingPassword ? null : onSaveChangesPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
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
