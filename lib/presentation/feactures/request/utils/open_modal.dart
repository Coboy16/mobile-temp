import 'package:flutter/material.dart';

import '/presentation/feactures/request/temp/mock_data.dart';
import '/presentation/widgets/widgets.dart';

void showApprovalFlow(BuildContext context, RequestData request) {
  // Paso 1: Mostrar modal de aprobación
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ApproveRequestModalWidget(
        request: request,
        onApprove: (comments) {
          // Cerrar el primer modal
          Navigator.of(context).pop();

          // Paso 2: Mostrar confirmación
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ConfirmActionModalWidget(
                message:
                    '¿Está completamente seguro de que desea aprobar esta solicitud? Esta acción no se puede deshacer.',
                confirmButtonColor: Colors.green,
                confirmButtonText: 'Confirmar',
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onConfirm: () {
                  // Cerrar modal de confirmación
                  Navigator.of(context).pop();

                  // Paso 3: Mostrar resultado exitoso
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return SuccessResultModalWidget(
                        title: 'Aprobación exitosa',
                        message: 'La solicitud ha sido aprobada correctamente.',
                        iconColor: Colors.green,
                        onAccept: () {
                          Navigator.of(context).pop();
                          // Mostrar mensaje de confirmación
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Solicitud de ${request.employeeName} aprobada',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}

void showRejectionFlow(BuildContext context, RequestData request) {
  // Paso 1: Mostrar modal de rechazo
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return RejectRequestModalWidget(
        request: request,
        onReject: (reason) {
          // Cerrar el primer modal
          Navigator.of(context).pop();

          // Paso 2: Mostrar confirmación
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ConfirmActionModalWidget(
                message:
                    '¿Está completamente seguro de que desea rechazar esta solicitud? Esta acción no se puede deshacer.',
                confirmButtonColor: Colors.red,
                confirmButtonText: 'Confirmar',
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onConfirm: () {
                  // Cerrar modal de confirmación
                  Navigator.of(context).pop();

                  // Paso 3: Mostrar resultado exitoso
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return SuccessResultModalWidget(
                        title: 'Rechazo exitoso',
                        message:
                            'La solicitud ha sido rechazada correctamente.',
                        iconColor: Colors.red,
                        onAccept: () {
                          Navigator.of(context).pop();
                          // Mostrar mensaje de confirmación
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Solicitud de ${request.employeeName} rechazada',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}
