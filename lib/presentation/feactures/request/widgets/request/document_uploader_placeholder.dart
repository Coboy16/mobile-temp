import 'package:flutter/material.dart';
import 'package:flutter_dotted/flutter_dotted.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DocumentUploaderPlaceholder extends StatelessWidget {
  const DocumentUploaderPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDotted(
      gap: 5,
      strokeWidth: 0.8,
      color: Colors.grey[400]!,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.upload, size: 35, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Haga clic para subir o arrastre y suelte',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'PDF, JPG, PNG, JPEG (máx. 5MB)',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
