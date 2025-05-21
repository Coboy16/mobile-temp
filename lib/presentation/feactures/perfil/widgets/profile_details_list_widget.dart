import 'package:flutter/material.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '/presentation/feactures/perfil/utils/user_temp.dart';

import 'profile_detail_card_widget.dart';

typedef OnUpdateFieldCallback =
    void Function(String fieldName, String newValue);

class ProfileDetailsList extends StatelessWidget {
  final UserProfileData userData;
  final OnUpdateFieldCallback onUpdateField;

  const ProfileDetailsList({
    super.key,
    required this.userData,
    required this.onUpdateField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileDetailCard(
          title: 'Nombre',
          currentValue: userData.firstName,
          formFieldName: 'firstName',
          displayIcon: FontAwesomeIcons.user,
          validators: [
            FormBuilderValidators.required(
              errorText: 'El nombre es requerido.',
            ),
          ],
          onSave: (newValue) => onUpdateField('firstName', newValue),
        ),
        ProfileDetailCard(
          title: 'Apellido Paterno',
          currentValue: userData.paternalLastName,
          formFieldName: 'paternalLastName',
          displayIcon: FontAwesomeIcons.user,
          validators: [
            FormBuilderValidators.required(
              errorText: 'El apellido paterno es requerido.',
            ),
          ],
          onSave: (newValue) => onUpdateField('paternalLastName', newValue),
        ),
        ProfileDetailCard(
          title: 'Apellido Materno',
          currentValue: userData.maternalLastName ?? '',
          formFieldName: 'maternalLastName',
          displayIcon: FontAwesomeIcons.user,
          onSave: (newValue) => onUpdateField('maternalLastName', newValue),
        ),
        ProfileDetailCard(
          title: 'Teléfono',
          currentValue: userData.phone ?? '',
          formFieldName: 'phone',
          displayIcon: FontAwesomeIcons.phone,
          keyboardType: TextInputType.phone,
          validators: [
            FormBuilderValidators.minLength(7, errorText: 'Mínimo 7 dígitos.'),
          ],
          onSave: (newValue) => onUpdateField('phone', newValue),
        ),
        ProfileDetailCard(
          title: 'Fecha de Nacimiento',
          currentValue:
              userData.birthday != null
                  ? DateFormat(
                    'MMM dd, yyyy',
                    'es_ES',
                  ).format(userData.birthday!)
                  : '',
          formFieldName: 'birthday',
          displayIcon: FontAwesomeIcons.calendarDay,
          hintText: 'Ej: Ene 12, 2004',
          validators: [
            (value) {
              if (value != null && value.isNotEmpty) {
                try {
                  DateFormat('MMM dd, yyyy', 'es_ES').parseStrict(value);
                  return null;
                } catch (e) {
                  return 'Formato: Mes Día, Año (Ene 01, 2000)';
                }
              }
              return null;
            },
          ],
          onSave: (newValue) => onUpdateField('birthday', newValue),
        ),
        ProfileDetailCard(
          title: 'Ciudad de Residencia',
          currentValue: userData.city ?? '',
          formFieldName: 'city',
          displayIcon: FontAwesomeIcons.city,
          onSave: (newValue) => onUpdateField('city', newValue),
        ),
      ],
    );
  }
}
