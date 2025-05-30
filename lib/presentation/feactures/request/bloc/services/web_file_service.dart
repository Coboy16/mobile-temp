import 'dart:async';

import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'file_service.dart';

import '/data/data.dart';

class WebFileService implements FileService {
  @override
  Future<List<UploadedFile>> pickFiles({
    required List<String> allowedExtensions,
    required int maxFiles,
  }) async {
    try {
      debugPrint('📁 Creating file input...');

      final input = html.FileUploadInputElement();
      input.accept = allowedExtensions.map((ext) => '.$ext').join(',');
      input.multiple = maxFiles > 1;

      // SOLUCIÓN: Agregar el input al DOM temporalmente
      html.document.body!.append(input);

      debugPrint('📁 Triggering file picker...');
      input.click();

      // SOLUCIÓN: Usar completer para mejor control
      final completer = Completer<List<UploadedFile>>();

      // Timer para timeout si el usuario cierra el diálogo
      Timer? timeoutTimer;

      input.onChange.listen((event) async {
        timeoutTimer?.cancel();
        debugPrint('📁 Files selected: ${input.files?.length ?? 0}');

        try {
          if (input.files?.isNotEmpty == true) {
            final files = <UploadedFile>[];

            for (final file in input.files!) {
              debugPrint('📄 Processing: ${file.name}');
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
            debugPrint('📁 No files selected');
            completer.complete([]);
          }
        } catch (e) {
          debugPrint('❌ Error processing files: $e');
          completer.completeError(e);
        } finally {
          // Limpiar el input del DOM
          input.remove();
        }
      });

      // // SOLUCIÓN: Detectar cuando se cierra el diálogo sin seleccionar
      // input.onCancel?.listen((event) {
      //   timeoutTimer?.cancel();
      //   debugPrint('📁 File picker cancelled');
      //   completer.complete([]);
      //   input.remove();
      // });

      // Timeout de seguridad (10 segundos)
      timeoutTimer = Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          debugPrint('⏰ File picker timeout');
          completer.complete([]);
          input.remove();
        }
      });

      // SOLUCIÓN: Detectar si el usuario hace clic fuera del diálogo
      html.window.addEventListener('focus', (event) {
        Timer(const Duration(milliseconds: 500), () {
          if (!completer.isCompleted && (input.files?.isEmpty ?? true)) {
            debugPrint('📁 File picker likely cancelled (focus returned)');
            timeoutTimer?.cancel();
            completer.complete([]);
            input.remove();
          }
        });
      });

      return await completer.future;
    } catch (e) {
      debugPrint('❌ Web file picker error: $e');
      return [];
    }
  }

  @override
  Future<List<UploadedFile>> processDroppedFiles(List<dynamic> files) async {
    debugPrint('📁 Processing ${files.length} dropped files');
    final uploadedFiles = <UploadedFile>[];

    for (final file in files) {
      if (file is html.File) {
        debugPrint('📄 Processing dropped file: ${file.name}');
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
          debugPrint('❌ Error processing dropped file ${file.name}: $e');
        }
      }
    }

    debugPrint('✅ Successfully processed ${uploadedFiles.length} files');
    return uploadedFiles;
  }

  Future<Uint8List> _readFileAsBytes(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }
}
