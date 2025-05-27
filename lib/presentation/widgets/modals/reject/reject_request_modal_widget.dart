import 'package:flutter/material.dart';

import '/presentation/feactures/request/temp/mock_data.dart';

class RejectRequestModalWidget extends StatefulWidget {
  final RequestData request;
  final Function(String) onReject;
  final VoidCallback onCancel;

  const RejectRequestModalWidget({
    super.key,
    required this.request,
    required this.onReject,
    required this.onCancel,
  });

  @override
  State<RejectRequestModalWidget> createState() =>
      _RejectRequestModalWidgetState();
}

class _RejectRequestModalWidgetState extends State<RejectRequestModalWidget> {
  final TextEditingController _reasonController = TextEditingController();
  bool _hasError = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    if (_reasonController.text.trim().isEmpty) {
      setState(() {
        _hasError = true;
      });
    } else {
      widget.onReject(_reasonController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con título y botón de cerrar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rechazar solicitud',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: widget.onCancel,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Mensaje de confirmación
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
                children: [
                  const TextSpan(text: '¿Está seguro que desea '),
                  TextSpan(
                    text: 'RECHAZAR',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' la solicitud de vacaciones de '),
                  TextSpan(
                    text: widget.request.employeeName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Campo de motivo de rechazo
            const Text(
              'Motivo del rechazo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Indique el motivo del rechazo...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF6C5DD3)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFFF5252)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFFF5252)),
                ),
                errorText: _hasError ? 'Este campo es obligatorio' : null,
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: (value) {
                if (_hasError && value.trim().isNotEmpty) {
                  setState(() {
                    _hasError = false;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón Cancelar
                TextButton(
                  onPressed: widget.onCancel,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    backgroundColor: const Color(0xFFF5F5F5),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Color(0xFF757575), fontSize: 14),
                  ),
                ),

                const SizedBox(width: 8),

                // Botón Rechazar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red,
                  ),
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Rechazar',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
