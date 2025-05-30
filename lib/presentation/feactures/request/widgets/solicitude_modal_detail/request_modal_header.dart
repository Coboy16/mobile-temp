import 'package:flutter/material.dart';

import '/data/data.dart';

class RequestModalHeader extends StatelessWidget {
  final RequestType requestType;
  final VoidCallback onClose;

  const RequestModalHeader({
    super.key,
    required this.requestType,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requestType.title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                requestType.subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: onClose,
            tooltip: 'Cerrar',
            color: Colors.black87,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
