import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'file_service.dart';
import '/data/data.dart';

class WebFileService implements FileService {
  WebFileService() {
    debugPrint('🌐 WebFileService initialized for web platform');
  }

  @override
  Future<List<UploadedFile>> pickFiles({
    required List<String> allowedExtensions,
    required int maxFiles,
  }) async {
    try {
      debugPrint('🌐📁 WebFileService: Creating file input...');

      final input = html.FileUploadInputElement();
      input.accept = allowedExtensions.map((ext) => '.$ext').join(',');
      input.multiple = maxFiles > 1;

      // SOLUCIÓN: Agregar el input al DOM temporalmente
      html.document.body!.append(input);

      debugPrint('🌐📁 WebFileService: Triggering file picker...');

      // SOLUCIÓN: Usar completer para mejor control
      final completer = Completer<List<UploadedFile>>();
      Timer? timeoutTimer;
      StreamSubscription? changeSubscription;
      bool isCompleted = false;

      // Configurar el listener ANTES de hacer click
      changeSubscription = input.onChange.listen((event) async {
        if (isCompleted) return;
        isCompleted = true;

        timeoutTimer?.cancel();
        changeSubscription?.cancel();

        debugPrint(
          '🌐📁 WebFileService: Files selected: ${input.files?.length ?? 0}',
        );

        try {
          if (input.files?.isNotEmpty == true) {
            final files = <UploadedFile>[];

            for (final file in input.files!) {
              debugPrint('🌐📄 WebFileService: Processing: ${file.name}');
              final bytes = await _readFileAsBytes(file);

              files.add(
                UploadedFile(
                  name: file.name,
                  size: file.size,
                  type: file.type,
                  bytes: bytes,
                ),
              );
            }

            completer.complete(files);
          } else {
            debugPrint('🌐📁 WebFileService: No files selected');
            completer.complete([]);
          }
        } catch (e) {
          debugPrint('🌐❌ WebFileService: Error processing files: $e');
          completer.completeError(e);
        } finally {
          // Limpiar el input del DOM
          input.remove();
        }
      });

      // Timeout de seguridad (30 segundos)
      timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!isCompleted) {
          isCompleted = true;
          debugPrint('🌐⏰ WebFileService: File picker timeout');
          changeSubscription?.cancel();
          completer.complete([]);
          input.remove();
        }
      });

      // SOLUCIÓN: Detectar si el usuario hace clic fuera del diálogo
      Timer(const Duration(milliseconds: 100), () {
        html.window.addEventListener('focus', (event) {
          Timer(const Duration(milliseconds: 500), () {
            if (!isCompleted && (input.files?.isEmpty ?? true)) {
              isCompleted = true;
              debugPrint(
                '🌐📁 WebFileService: File picker likely cancelled (focus returned)',
              );
              timeoutTimer?.cancel();
              changeSubscription?.cancel();
              completer.complete([]);
              input.remove();
            }
          });
        });
      });

      // Hacer click después de configurar todo
      input.click();

      return await completer.future;
    } catch (e) {
      debugPrint('🌐❌ WebFileService: File picker error: $e');
      return [];
    }
  }

  @override
  Future<List<UploadedFile>> processDroppedFiles(List<dynamic> files) async {
    debugPrint('🌐📁 WebFileService: Processing ${files.length} dropped files');
    final uploadedFiles = <UploadedFile>[];

    for (final file in files) {
      if (file is html.File) {
        debugPrint(
          '🌐📄 WebFileService: Processing dropped file: ${file.name}',
        );
        try {
          final bytes = await _readFileAsBytes(file);

          uploadedFiles.add(
            UploadedFile(
              name: file.name,
              size: file.size,
              type: file.type,
              bytes: bytes,
            ),
          );
        } catch (e) {
          debugPrint(
            '🌐❌ WebFileService: Error processing dropped file ${file.name}: $e',
          );
        }
      }
    }

    debugPrint(
      '🌐✅ WebFileService: Successfully processed ${uploadedFiles.length} files',
    );
    return uploadedFiles;
  }

  Future<Uint8List> _readFileAsBytes(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }
}
