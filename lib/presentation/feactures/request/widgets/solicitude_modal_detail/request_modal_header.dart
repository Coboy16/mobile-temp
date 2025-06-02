import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '/data/data.dart';

class RequestModalHeader extends StatelessWidget {
  final RequestType requestType;
  final VoidCallback onClose;
  final bool isMobile;

  const RequestModalHeader({
    super.key,
    required this.requestType,
    required this.onClose,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20.0 : 24.0,
        isMobile ? 20.0 : 24.0,
        isMobile ? 20.0 : 24.0,
        16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  requestType.title,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: isMobile ? 2 : 1,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                AutoSizeText(
                  requestType.subtitle,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    color: Colors.black87,
                  ),
                  maxLines: isMobile ? 2 : 1,
                  minFontSize: 12,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.close, size: isMobile ? 20 : 16),
            onPressed: onClose,
            tooltip: 'Cerrar',
            color: Colors.black87,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
