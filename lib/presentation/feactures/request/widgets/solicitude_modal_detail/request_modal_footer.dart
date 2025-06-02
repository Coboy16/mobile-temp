import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/data/data.dart';

class RequestModalFooter extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final RequestType requestType;
  final bool isMobile;

  const RequestModalFooter({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.requestType,
    this.isMobile = false,
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

  String get _submitButtonTextMobile {
    switch (requestType) {
      case RequestType.vacation:
        return 'Enviar solicitud';
      case RequestType.permission:
        return 'Enviar solicitud';
      case RequestType.medicalLeave:
        return 'Enviar solicitud';
      case RequestType.suspension:
        return 'Enviar solicitud';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20.0 : 24.0,
        16.0,
        isMobile ? 20.0 : 24.0,
        isMobile ? 20.0 : 24.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Row(
      children: [
        // Botón cancelar
        Expanded(
          child: ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300, width: 0.4),
              backgroundColor: const Color(0xfff9f9fc),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Botón principal
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: AutoSizeText(
              _submitButtonTextMobile,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              minFontSize: 13,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
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
          child: AutoSizeText(
            _submitButtonText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            minFontSize: 12,
          ),
        ),
      ],
    );
  }
}
