import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'file_service.dart';
import '/data/data.dart';

class MobileFileService implements FileService {
  @override
  Future<List<UploadedFile>> pickFiles({
    required List<String> allowedExtensions,
    required int maxFiles,
  }) async {
    try {
      debugPrint('📱 Opening mobile file picker...');

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: maxFiles > 1,
        withData: true, // Importante: obtener los bytes del archivo
      );

      if (result != null && result.files.isNotEmpty) {
        final uploadedFiles = <UploadedFile>[];

        for (PlatformFile file in result.files) {
          if (file.bytes != null) {
            debugPrint('📄 Processing mobile file: ${file.name}');

            uploadedFiles.add(
              UploadedFile(
                name: file.name,
                size: file.size,
                type: _getMimeType(file.extension ?? ''),
                bytes: file.bytes!,
              ),
            );
          }
        }

        debugPrint('✅ Mobile files processed: ${uploadedFiles.length}');
        return uploadedFiles;
      }

      debugPrint('📱 No files selected in mobile picker');
      return [];
    } catch (e) {
      debugPrint('❌ Mobile file picker error: $e');
      return [];
    }
  }

  @override
  Future<List<UploadedFile>> processDroppedFiles(List<dynamic> files) async {
    // Drag & drop no está disponible en móvil
    debugPrint('📱 Drag & drop not available on mobile');
    return [];
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }
}
