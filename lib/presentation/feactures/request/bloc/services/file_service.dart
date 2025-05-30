import 'package:flutter/foundation.dart';
import '/data/data.dart';

import 'mobile_file_service.dart';
import 'web_file_service.dart' if (dart.library.io) 'mobile_file_service.dart';

abstract class FileService {
  factory FileService() {
    if (kIsWeb) {
      return WebFileService();
    } else {
      return MobileFileService();
    }
  }

  Future<List<UploadedFile>> pickFiles({
    required List<String> allowedExtensions,
    required int maxFiles,
  });

  Future<List<UploadedFile>> processDroppedFiles(List<dynamic> files);
}
