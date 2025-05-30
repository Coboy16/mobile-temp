import 'package:flutter/foundation.dart';
import 'file_service.dart';
import 'mobile_file_service.dart';

FileService createWebFileService() {
  debugPrint(
    '📱 Stub: createWebFileService called on mobile, returning MobileFileService',
  );
  return MobileFileService();
}
