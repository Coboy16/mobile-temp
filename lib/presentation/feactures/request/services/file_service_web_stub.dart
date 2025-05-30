import 'package:flutter/foundation.dart';
import '/data/data.dart';
import 'file_service.dart';

/// Implementación stub para móvil que NO usa dart:html
class WebFileService implements FileService {
  @override
  Future<List<UploadedFile>> pickFiles({
    required List<String> allowedExtensions,
    required int maxFiles,
  }) async {
    debugPrint('❌ WebFileService stub: No implementado en móvil');
    throw UnsupportedError('WebFileService solo está disponible en web');
  }

  @override
  Future<List<UploadedFile>> processDroppedFiles(List<dynamic> files) async {
    debugPrint('❌ WebFileService stub: Drag & drop no disponible en móvil');
    return [];
  }
}
