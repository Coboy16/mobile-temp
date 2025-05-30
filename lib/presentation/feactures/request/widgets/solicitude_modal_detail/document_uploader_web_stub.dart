import 'package:flutter/material.dart';
import '/data/data.dart';

/// Implementación stub para móvil que NO usa dart:html
class DocumentUploaderWeb extends StatelessWidget {
  final Function(List<UploadedFile>)? onFilesChanged;
  final List<String> allowedExtensions;
  final int maxFileSizeMB;
  final int maxFiles;
  final bool allowMultiple;

  const DocumentUploaderWeb({
    super.key,
    this.onFilesChanged,
    this.allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
    this.maxFileSizeMB = 5,
    this.maxFiles = 1,
    this.allowMultiple = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        'DocumentUploaderWeb stub - no debería verse en móvil',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
