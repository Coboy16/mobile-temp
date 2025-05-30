import 'package:flutter/foundation.dart';
import 'file_service.dart';

import '/data/data.dart';

class MobileFileService implements FileService {
  @override
  Future<List<UploadedFile>> pickFiles({
    required List<String> allowedExtensions,
    required int maxFiles,
  }) async {
    // Implementar con image_picker o file_picker nativo
    debugPrint('📱 Mobile file picker not implemented yet');
    return [];
  }

  @override
  Future<List<UploadedFile>> processDroppedFiles(List<dynamic> files) async {
    // Drag & drop no disponible en móvil
    return [];
  }
}
