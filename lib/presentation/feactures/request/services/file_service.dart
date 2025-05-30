import 'package:flutter/foundation.dart';
import '/data/data.dart';

import 'mobile_file_service.dart';
import 'file_service_web_stub.dart'
    if (dart.library.html) 'web_file_service.dart';

abstract class FileService {
  factory FileService() {
    return MobileFileService();
  }

  Future<List<UploadedFile>> pickFiles({
    required List<String> allowedExtensions,
    required int maxFiles,
  });

  Future<List<UploadedFile>> processDroppedFiles(List<dynamic> files);
}

class WebFileServiceFactory {
  static FileService? _instance;

  static FileService getInstance() {
    if (kIsWeb) {
      _instance ??= WebFileService();
      return _instance!;
    } else {
      return MobileFileService();
    }
  }
}
