import 'package:flutter/material.dart';

import '/data/data.dart';

class RequestModalFooter extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final RequestType requestType;

  const RequestModalFooter({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.requestType,
  });

  String get _submitButtonText {
    switch (requestType) {
      case RequestType.vacation:
        return 'Enviar solicitud de vacaciones';
      case RequestType.permission:
        return 'Enviar solicitud de permiso';
      case RequestType.medicalLeave:
        return 'Enviar solicitud de licencia';
      case RequestType.suspension:
        return 'Enviar solicitud de suspensión';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300, width: 0.4),
              backgroundColor: const Color(0xfff9f9fc),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              _submitButtonText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
