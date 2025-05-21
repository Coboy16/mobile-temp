import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:intl/intl.dart';

import '/presentation/feactures/perfil/utils/user_temp.dart';
import '/presentation/feactures/perfil/widgets/widgets.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  UserProfileData _userData = UserProfileData(
    firstName: "Olivia",
    paternalLastName: "Wilfson",
    email: "olivia.wilfson@example.com",
    phone: "+1-956-945-3210",
    birthday: DateTime(2004, 1, 12),
    city: "Los Angeles, CA",
  );

  final _securityFormKey = GlobalKey<FormBuilderState>();

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyText2.copyWith(
            color: isError ? AppColors.onError : AppColors.onPrimary,
          ),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.primaryVariant,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _onUpdateField(String fieldName, String newValue) {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        String displayFieldName = fieldName;
        // Mapeo de fieldName a su representación en español para el SnackBar
        const fieldNameMap = {
          'firstName': 'Nombre',
          'paternalLastName': 'Apellido Paterno',
          'maternalLastName': 'Apellido Materno',
          'phone': 'Teléfono',
          'birthday': 'Fecha de Nacimiento',
          'city': 'Ciudad de Residencia',
          'postCode': 'Código Postal',
        };
        displayFieldName = fieldNameMap[fieldName] ?? fieldName;

        try {
          // Crear una copia del UserProfileData con el campo actualizado
          Map<String, dynamic> updates = {fieldName: newValue};
          if (fieldName == 'birthday' && newValue.isNotEmpty) {
            updates[fieldName] = DateFormat(
              'MMM dd, yyyy',
              'es_ES',
            ).parseStrict(newValue);
          } else if (fieldName == 'maternalLastName' ||
              fieldName == 'phone' ||
              fieldName == 'city' ||
              fieldName == 'postCode') {
            updates[fieldName] = newValue.isNotEmpty ? newValue : null;
          }

          _userData = _userData.copyWith(
            firstName:
                fieldName == 'firstName' ? newValue : _userData.firstName,
            paternalLastName:
                fieldName == 'paternalLastName'
                    ? newValue
                    : _userData.paternalLastName,
            maternalLastName:
                fieldName == 'maternalLastName'
                    ? (newValue.isNotEmpty ? newValue : null)
                    : _userData.maternalLastName,
            phone:
                fieldName == 'phone'
                    ? (newValue.isNotEmpty ? newValue : null)
                    : _userData.phone,
            birthday:
                fieldName == 'birthday'
                    ? (newValue.isNotEmpty
                        ? DateFormat(
                          'MMM dd, yyyy',
                          'es_ES',
                        ).parseStrict(newValue)
                        : null)
                    : _userData.birthday,
            city:
                fieldName == 'city'
                    ? (newValue.isNotEmpty ? newValue : null)
                    : _userData.city,
          );
          _showSnackBar(
            '${_capitalizeFirstLetter(displayFieldName)} actualizado con éxito!',
          );
        } catch (e) {
          if (fieldName == 'birthday') {
            _showSnackBar(
              'Formato de fecha inválido. Usar: Mes Día, Año (Ej: Ene 12, 2004)',
              isError: true,
            );
          } else {
            _showSnackBar(
              'Error al actualizar $displayFieldName.',
              isError: true,
            );
          }
        }
      });
    });
  }

  void _onSaveChangesPassword() {
    if (_securityFormKey.currentState?.saveAndValidate() ?? false) {
      final currentPassword =
          _securityFormKey.currentState!.value['contrasenaActual'] as String?;
      final newPassword =
          _securityFormKey.currentState!.value['contrasenaNueva'] as String?;

      if (currentPassword != "password123") {
        _showSnackBar('La contraseña actual es incorrecta.', isError: true);
        _securityFormKey.currentState?.fields['contrasenaActual']?.invalidate(
          'Contraseña incorrecta',
        );
        return;
      }

      if (newPassword != null && newPassword.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _showSnackBar('Contraseña actualizada con éxito');
          _securityFormKey.currentState?.reset();
        });
      } else {
        _showSnackBar('No se especificó una nueva contraseña.', isError: true);
      }
    } else {
      _showSnackBar(
        'Por favor, corrige los errores en la sección de seguridad.',
        isError: true,
      );
    }
  }

  Future<void> _onDeleteAccount() async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Eliminar Cuenta',
      message:
          '¿Estás seguro? Esta acción es irreversible y todos tus datos serán eliminados permanentemente.',
      okLabel: 'Sí, Eliminar',
      cancelLabel: 'Cancelar',
      isDestructiveAction: true,
      barrierDismissible: true,
      builder:
          (context, child) => Theme(
            data: ThemeData(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTextStyles.button.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            child: child,
          ),
    );
    if (result == OkCancelResult.ok) {
      _showSnackBar(
        'Solicitud de eliminación de cuenta procesada (simulación). Serás redirigido.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    final useTwoColumnLayout = ResponsiveBreakpoints.of(
      context,
    ).largerThan(MOBILE);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: MaxWidthBox(
          maxWidth: useTwoColumnLayout ? 1100 : 700,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.0 : (useTwoColumnLayout ? 32.0 : 24.0),
              vertical: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileHeader(userData: _userData, isMobile: isMobile),
                const SizedBox(height: 32.0),
                if (useTwoColumnLayout)
                  _buildWebContent(isMobile)
                else
                  _buildMobileContent(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileDetailsList(userData: _userData, onUpdateField: _onUpdateField),
        const SizedBox(height: 24.0),
        SecuritySettingsCard(
          formKey: _securityFormKey,
          email: _userData.email,
          onSaveChangesPassword: _onSaveChangesPassword,
        ),
        const SizedBox(height: 32.0),
        ProfileActions(onDeleteAccount: _onDeleteAccount, isMobile: isMobile),
      ],
    );
  }

  Widget _buildWebContent(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: ProfileDetailsList(
            userData: _userData,
            onUpdateField: _onUpdateField,
          ),
        ),
        const SizedBox(width: 32.0),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SecuritySettingsCard(
                formKey: _securityFormKey,
                email: _userData.email,
                onSaveChangesPassword: _onSaveChangesPassword,
              ),
              const SizedBox(height: 24.0),
              ProfileActions(
                onDeleteAccount: _onDeleteAccount,
                isMobile: isMobile,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
