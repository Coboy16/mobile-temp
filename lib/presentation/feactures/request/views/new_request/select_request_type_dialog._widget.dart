import 'package:fe_core_vips/presentation/resources/colors.dart';
import 'package:flutter/material.dart';
import '../vacation_request/vacation_request_screen.dart';
import '/presentation/feactures/request/temp/request_options.dart';

class SelectRequestTypeDialog extends StatelessWidget {
  const SelectRequestTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      insetPadding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1000, // Más ancho para el layout horizontal
          maxHeight: 520, // Menos altura para que sea más rectangular
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y botón cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selecciona el tipo de solicitud',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Elige el tipo de solicitud que deseas crear',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 16,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Grid de opciones
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio:
                        2.0, // Cambiado de 1.2 a 2.0 para cards más rectangulares
                  ),
                  itemCount:
                      requestOptions.length, // Usando requestOptions original
                  itemBuilder: (context, index) {
                    return _buildOptionCard(context, requestOptions[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, RequestTypeOption option) {
    return InkWell(
      onTap: () {
        print('Opción seleccionada: ${option.title} (ID: ${option.typeId})');
        _handleRequestTypeSelection(context, option.typeId);
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, // Centrado vertical
          children: [
            // Icono y título
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  maxRadius: 16,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      option.icon,
                      size: 18,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade900,
                      letterSpacing: -0.1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Espaciado reducido
            // Descripción
            Text(
              option.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.3, // Altura de línea más compacta
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Maneja la selección del tipo de solicitud
  void _handleRequestTypeSelection(BuildContext context, String typeId) {
    Navigator.of(context).pop();

    switch (typeId) {
      case 'vacation':
        _openVacationRequest(context);
        break;
      case 'permit':
        _openPermitRequest(context);
        break;
      case 'medical':
        _openMedicalLeaveRequest(context);
        break;
      case 'suspension':
        _openSuspensionRequest(context);
        break;
      case 'schedule_change':
        _openScheduleChangeRequest(context);
        break;
      case 'position_change':
        _openPositionChangeRequest(context);
        break;
      case 'tip_change':
        _openTipChangeRequest(context);
        break;
      case 'advance':
        _openAdvanceRequest(context);
        break;
      case 'letter':
        _openLetterRequest(context);
        break;
      case 'uniform':
        _openUniformRequest(context);
        break;
      case 'housing_change':
        _openHousingChangeRequest(context);
        break;
      case 'exit':
        _openExitRequest(context);
        break;
      default:
        _showNotImplementedDialog(context, typeId);
    }
  }

  // Métodos de navegación (sin cambios del código original)
  void _openVacationRequest(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const VacationRequestModal();
      },
    );
  }

  void _openPermitRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Solicitud de Permiso');
  }

  void _openMedicalLeaveRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Licencia Médica');
  }

  void _openSuspensionRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Solicitud de Suspensión');
  }

  void _openScheduleChangeRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Cambio de Horario');
  }

  void _openPositionChangeRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Cambio de Posición');
  }

  void _openTipChangeRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Cambio de Propina');
  }

  void _openAdvanceRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Solicitud de Avance');
  }

  void _openLetterRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Solicitud de Carta');
  }

  void _openUniformRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Solicitud de Uniforme');
  }

  void _openHousingChangeRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Cambio de Alojamiento');
  }

  void _openExitRequest(BuildContext context) {
    _showComingSoonDialog(context, 'Solicitud de Salida');
  }

  void _showNotImplementedDialog(BuildContext context, String typeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tipo no implementado'),
          content: Text('El tipo de solicitud "$typeId" no está implementado.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String requestType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Próximamente'),
          content: Text(
            'La funcionalidad "$requestType" estará disponible pronto.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Clase para definir las opciones de solicitud (si no existe en tu imports)
// Esta clase puede ser removida si ya tienes RequestTypeOption en request_options.dart
// class RequestTypeOption {
//   final String typeId;
//   final String title;
//   final String description;
//   final IconData icon;

//   RequestTypeOption({
//     required this.typeId,
//     required this.title,
//     required this.description,
//     required this.icon,
//   });
// }

// Función helper para mostrar el selector de tipos de solicitud
class RequestTypeHelper {
  static Future<void> showRequestTypeSelector(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const SelectRequestTypeDialog();
      },
    );
  }
}
