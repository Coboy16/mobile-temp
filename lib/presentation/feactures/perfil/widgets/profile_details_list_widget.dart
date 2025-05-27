import 'package:flutter/material.dart';

import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/domain/domain.dart';
import 'profile_detail_card_widget.dart';

typedef OnUpdateFieldCallback =
    void Function(String fieldName, String newValue);

class ProfileDetailsList extends StatelessWidget {
  final UserDetailsEntity? userDataFromEntity;
  final OnUpdateFieldCallback onUpdateField;

  const ProfileDetailsList({
    super.key,
    required this.userDataFromEntity,
    required this.onUpdateField,
  });

  @override
  Widget build(BuildContext context) {
    if (userDataFromEntity == null) {
      void dummyOnSave(newValue) {
        debugPrint(
          "Intento de guardar mientras los datos están cargando: $newValue",
        );
      }

      return Column(
        children: [
          ProfileDetailCard(
            title: 'Nombre',
            currentValue: 'Cargando...',
            formFieldName: 'name_loading',
            displayIcon: LucideIcons.user,
            readOnly: true,
            onSave: dummyOnSave,
          ),
          ProfileDetailCard(
            title: 'Apellido Paterno',
            currentValue: 'Cargando...',
            formFieldName: 'fatherLastname_loading',
            displayIcon: LucideIcons.user,
            readOnly: true,
            onSave: dummyOnSave,
          ),
          ProfileDetailCard(
            title: 'Apellido Materno',
            currentValue: 'Cargando...',
            formFieldName: 'motherLastname_loading',
            displayIcon: LucideIcons.user,
            readOnly: true,
            onSave: dummyOnSave,
          ),
        ],
      );
    }

    return Column(
      children: [
        ProfileDetailCard(
          title: 'Nombre',
          currentValue: userDataFromEntity!.name,
          formFieldName: 'name',
          displayIcon: LucideIcons.user,
          validators: [
            FormBuilderValidators.required(
              errorText: 'El nombre es requerido.',
            ),
          ],
          onSave: (newValue) => onUpdateField('name', newValue),
        ),
        ProfileDetailCard(
          title: 'Apellido Paterno',
          currentValue: userDataFromEntity!.fatherLastname ?? '',
          formFieldName: 'fatherLastname',
          displayIcon: LucideIcons.user,
          validators: [
            FormBuilderValidators.required(
              errorText: 'El apellido paterno es requerido.',
            ),
          ],
          onSave: (newValue) => onUpdateField('fatherLastname', newValue),
        ),
        ProfileDetailCard(
          title: 'Apellido Materno',
          currentValue: userDataFromEntity!.motherLastname ?? '',
          formFieldName: 'motherLastname',
          displayIcon: LucideIcons.user,
          onSave: (newValue) => onUpdateField('motherLastname', newValue),
        ),
        ProfileDetailCard(
          title: 'Correo Electrónico (No editable)',
          currentValue: userDataFromEntity!.email,
          formFieldName: 'motherLastname',
          displayIcon: LucideIcons.mail,
          readOnly: true,
          onSave: (dummyValue) {},
        ),
      ],
    );
  }
}
