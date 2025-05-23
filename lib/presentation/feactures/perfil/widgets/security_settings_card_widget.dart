// SecuritySettingsCard.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/resources/resources.dart';
import 'custom_text_form_field_widget.dart'; // Tu widget
import 'profile_section_container_widget.dart';

class SecuritySettingsCard extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final String email;
  final VoidCallback onSaveChangesPassword;
  final bool isChangingPassword; // <--- AÑADIDO

  const SecuritySettingsCard({
    super.key,
    required this.formKey,
    required this.email,
    required this.onSaveChangesPassword,
    this.isChangingPassword = false, // <--- AÑADIDO: Con valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionContainer(
      title: 'Seguridad',
      titleCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilder(
          key: formKey,
          // El FormBuilder en sí no necesita ser deshabilitado si los campos individuales lo están.
          // enabled: !isChangingPassword, // Opcional: Podrías deshabilitar todo el form.
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
                          child: Icon(
                            LucideIcons.mail,
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
              // Campo "Contraseña Actual" eliminado según el nuevo enfoque
              // CustomTextFormField(
              //   name: 'contrasenaActual',
              //   ...
              // ),
              CustomTextFormField(
                name: 'contrasenaNueva',
                labelText: 'Nueva Contraseña',
                hintText: 'Mínimo 8 caracteres',
                obscureText: true,
                prefixIcon: const Icon(LucideIcons.lock),
                readOnly: isChangingPassword, // <--- MODIFICADO: Usar readOnly
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
                    // <--- AÑADIDO: Condición
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
                prefixIcon: const Icon(LucideIcons.lock),
                readOnly: isChangingPassword, // <--- MODIFICADO: Usar readOnly
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
                  // --- MODIFICADO: Botón ---
                  icon:
                      isChangingPassword
                          ? Container() // Ocultar icono durante la carga
                          : const Icon(LucideIcons.refreshCcw, size: 18),
                  label:
                      isChangingPassword
                          ? SizedBox(
                            height: 20, // Ajusta según el estilo de tu app
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.onPrimary,
                              ),
                            ),
                          )
                          : const Text('Actualizar Contraseña'),
                  onPressed:
                      isChangingPassword
                          ? null
                          : onSaveChangesPassword, // Deshabilitar si está cargando
                  // --- Fin Modificación Botón ---
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
