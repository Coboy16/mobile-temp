import 'dart:html' as html;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '/data/data.dart';
import 'file_service.dart';

FileService createWebFileService() {
  debugPrint('🌐 Creating REAL WebFileService');
  return _WebFileServiceImpl();
}

class _WebFileServiceImpl implements FileService {
  _WebFileServiceImpl() {
    debugPrint('🌐 _WebFileServiceImpl initialized for web platform');
  }

  @override
  Future<List<UploadedFile>> pickFiles({
    required List<String> allowedExtensions,
    required int maxFiles,
  }) async {
    try {
      debugPrint('🌐📁 _WebFileServiceImpl: Creating file input...');

      final input = html.FileUploadInputElement();
      input.accept = allowedExtensions.map((ext) => '.$ext').join(',');
      input.multiple = maxFiles > 1;

      html.document.body!.append(input);
      debugPrint('🌐📁 _WebFileServiceImpl: Triggering file picker...');

      final completer = Completer<List<UploadedFile>>();
      Timer? timeoutTimer;
      StreamSubscription? changeSubscription;
      bool isCompleted = false;

      changeSubscription = input.onChange.listen((event) async {
        if (isCompleted) return;
        isCompleted = true;

        timeoutTimer?.cancel();
        changeSubscription?.cancel();

        debugPrint(
          '🌐📁 _WebFileServiceImpl: Files selected: ${input.files?.length ?? 0}',
        );

        try {
          if (input.files?.isNotEmpty == true) {
            final files = <UploadedFile>[];

            for (final file in input.files!) {
              debugPrint('🌐📄 _WebFileServiceImpl: Processing: ${file.name}');
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
            debugPrint('🌐📁 _WebFileServiceImpl: No files selected');
            completer.complete([]);
          }
        } catch (e) {
          debugPrint('🌐❌ _WebFileServiceImpl: Error processing files: $e');
          completer.completeError(e);
        } finally {
          input.remove();
        }
      });

      timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!isCompleted) {
          isCompleted = true;
          debugPrint('🌐⏰ _WebFileServiceImpl: File picker timeout');
          changeSubscription?.cancel();
          completer.complete([]);
          input.remove();
        }
      });

      Timer(const Duration(milliseconds: 100), () {
        html.window.addEventListener('focus', (event) {
          Timer(const Duration(milliseconds: 500), () {
            if (!isCompleted && (input.files?.isEmpty ?? true)) {
              isCompleted = true;
              debugPrint('🌐📁 _WebFileServiceImpl: File picker cancelled');
              timeoutTimer?.cancel();
              changeSubscription?.cancel();
              completer.complete([]);
              input.remove();
            }
          });
        });
      });

      input.click();
      return await completer.future;
    } catch (e) {
      debugPrint('🌐❌ _WebFileServiceImpl: File picker error: $e');
      return [];
    }
  }

  @override
  Future<List<UploadedFile>> processDroppedFiles(List<dynamic> files) async {
    debugPrint(
      '🌐📁 _WebFileServiceImpl: Processing ${files.length} dropped files',
    );
    final uploadedFiles = <UploadedFile>[];

    for (final file in files) {
      if (file is html.File) {
        debugPrint(
          '🌐📄 _WebFileServiceImpl: Processing dropped file: ${file.name}',
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
            '🌐❌ _WebFileServiceImpl: Error processing dropped file ${file.name}: $e',
          );
        }
      }
    }

    debugPrint(
      '🌐✅ _WebFileServiceImpl: Successfully processed ${uploadedFiles.length} files',
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
