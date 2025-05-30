import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'document_uploader_mobile.dart';
import 'document_uploader_web_stub.dart'
    if (dart.library.html) 'document_uploader_web.dart';

import '/presentation/feactures/request/bloc/bloc.dart';

import '/data/data.dart';

class DocumentUploaderUniversal extends StatelessWidget {
  final Function(List<UploadedFile>)? onFilesChanged;
  final List<String> allowedExtensions;
  final int maxFileSizeMB;
  final int maxFiles;
  final bool allowMultiple;

  const DocumentUploaderUniversal({
    super.key,
    this.onFilesChanged,
    this.allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
    this.maxFileSizeMB = 5,
    this.maxFiles = 1,
    this.allowMultiple = false,
  });

  /// Factory method para crear el widget apropiado según la plataforma
  static Widget create({
    Key? key,
    Function(List<UploadedFile>)? onFilesChanged,
    List<String> allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
    int maxFileSizeMB = 5,
    int maxFiles = 1,
    bool allowMultiple = false,
  }) {
    return DocumentUploaderUniversal(
      key: key,
      onFilesChanged: onFilesChanged,
      allowedExtensions: allowedExtensions,
      maxFileSizeMB: maxFileSizeMB,
      maxFiles: maxFiles,
      allowMultiple: allowMultiple,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('📱 DocumentUploaderUniversal build - kIsWeb: $kIsWeb');

    // Decidir qué implementación usar según la plataforma
    if (kIsWeb) {
      // En web, usar la versión con drag & drop
      return BlocProvider(
        create: (context) {
          debugPrint('🌐 Creating FileUploadBloc for web with WebFileService');
          return FileUploadBloc(
            allowedExtensions: allowedExtensions,
            maxFileSizeMB: maxFileSizeMB,
            maxFiles: maxFiles,
            // El FileService() factory manejará la creación correcta
          );
        },
        child: DocumentUploaderWeb(
          onFilesChanged: onFilesChanged,
          allowedExtensions: allowedExtensions,
          maxFileSizeMB: maxFileSizeMB,
          maxFiles: maxFiles,
          allowMultiple: allowMultiple,
        ),
      );
    } else {
      // En móvil, usar la versión móvil
      return BlocProvider(
        create: (context) {
          debugPrint(
            '📱 Creating FileUploadBloc for mobile with MobileFileService',
          );
          return FileUploadBloc(
            allowedExtensions: allowedExtensions,
            maxFileSizeMB: maxFileSizeMB,
            maxFiles: maxFiles,
            // El FileService() factory manejará la creación correcta
          );
        },
        child: DocumentUploaderMobile(
          onFilesChanged: onFilesChanged,
          allowedExtensions: allowedExtensions,
          maxFileSizeMB: maxFileSizeMB,
          maxFiles: maxFiles,
          allowMultiple: allowMultiple,
        ),
      );
    }
  }
}
