import 'package:flutter/material.dart';

import '/presentation/feactures/request/views/views.dart';
import '/data/data.dart';

class RequestModalHelper {
  // Método genérico
  static Future<Map<String, dynamic>?> showRequestModal(
    BuildContext context,
    RequestType requestType, {
    Function(RequestFormData)? onSubmit,
  }) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GenericRequestModal(
          requestType: requestType,
          onSubmit: onSubmit,
        );
      },
    );
  }

  // Métodos específicos para cada tipo (para mantener compatibilidad)
  static Future<Map<String, dynamic>?> showVacationRequestModal(
    BuildContext context, {
    Function(RequestFormData)? onSubmit,
  }) async {
    return showRequestModal(context, RequestType.vacation, onSubmit: onSubmit);
  }

  static Future<Map<String, dynamic>?> showPermissionRequestModal(
    BuildContext context, {
    Function(RequestFormData)? onSubmit,
  }) async {
    return showRequestModal(
      context,
      RequestType.permission,
      onSubmit: onSubmit,
    );
  }

  static Future<Map<String, dynamic>?> showMedicalLeaveRequestModal(
    BuildContext context, {
    Function(RequestFormData)? onSubmit,
  }) async {
    return showRequestModal(
      context,
      RequestType.medicalLeave,
      onSubmit: onSubmit,
    );
  }

  static Future<Map<String, dynamic>?> showSuspensionRequestModal(
    BuildContext context, {
    Function(RequestFormData)? onSubmit,
  }) async {
    return showRequestModal(
      context,
      RequestType.suspension,
      onSubmit: onSubmit,
    );
  }
}
