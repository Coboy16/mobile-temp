import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/data/data.dart';

class MedicalLicenseTypeDropdown extends StatelessWidget {
  const MedicalLicenseTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionHeader(title: 'Tipo de licencia', isRequired: true),
        // Envolver en un contenedor con ancho controlado
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 565, // Ajustar al ancho máximo disponible en el modal
          ),
          child: Theme(
            // Personalizar el tema del dropdown para cambiar colores
            data: Theme.of(context).copyWith(
              // Color de fondo del item seleccionado
              focusColor: Colors.grey.shade200,
              hoverColor: Colors.grey.shade100,
              // Color del texto
              textTheme: Theme.of(context).textTheme.copyWith(
                bodyMedium: const TextStyle(color: Colors.black),
              ),
            ),
            child: FormBuilderDropdown<MedicalLicenseType>(
              name: 'medical_license_type',
              decoration: InputDecoration(
                hintText: 'Seleccionar tipo de licencia',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.4,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.4,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
              // Valor inicial por defecto
              initialValue: MedicalLicenseType.maternity,
              // Altura máxima del dropdown y configuración para evitar superposición
              menuMaxHeight: 250,
              isDense: true, // Hace el dropdown más compacto
              // Offset para posicionar el dropdown correctamente
              elevation: 8, // Elevación para que se vea por encima
              // Personalizar items del dropdown con altura reducida
              items:
                  MedicalLicenseType.values
                      .map(
                        (type) => DropdownMenuItem<MedicalLicenseType>(
                          value: type,
                          child: Container(
                            width: double.infinity,
                            height:
                                40, // Altura fija más pequeña para cada item
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8, // Padding vertical reducido
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              type.displayName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              // Personalizar el estilo del dropdown
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              // Validación
              validator: (value) {
                if (value == null) {
                  return 'Debe seleccionar el tipo de licencia';
                }
                return null;
              },
              // Personalizar el item seleccionado
              selectedItemBuilder: (BuildContext context) {
                return MedicalLicenseType.values.map<Widget>((type) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      type.displayName,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              // Configuración adicional para el comportamiento del dropdown
              iconEnabledColor: Colors.grey.shade600,
              iconDisabledColor: Colors.grey.shade400,
              iconSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
