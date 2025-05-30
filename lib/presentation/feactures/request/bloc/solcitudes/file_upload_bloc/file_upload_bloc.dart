import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '/data/data.dart';
import '/presentation/feactures/request/bloc/services/services.dart';

part 'file_upload_event.dart';
part 'file_upload_state.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final FileService _fileService;
  final List<String> allowedExtensions;
  final int maxFileSizeMB;
  final int maxFiles;

  FileUploadBloc({
    required this.allowedExtensions,
    required this.maxFileSizeMB,
    required this.maxFiles,
  }) : _fileService = FileService(),
       super(FileUploadInitial()) {
    on<TriggerFilePickerEvent>(_onTriggerFilePicker);
    on<ProcessDroppedFilesEvent>(_onProcessDroppedFiles);
    on<AddFilesEvent>(_onAddFiles);
    on<RemoveFileEvent>(_onRemoveFile);
    on<ClearFilesEvent>(_onClearFiles);
  }

  List<UploadedFile> get _currentFiles {
    if (state is FileUploadSuccess) {
      return (state as FileUploadSuccess).files;
    } else if (state is FileUploadError) {
      return (state as FileUploadError).files;
    }
    return [];
  }

  Future<void> _onTriggerFilePicker(
    TriggerFilePickerEvent event,
    Emitter<FileUploadState> emit,
  ) async {
    try {
      emit(const FileUploadLoading());

      final files = await _fileService.pickFiles(
        allowedExtensions: allowedExtensions,
        maxFiles: maxFiles == 1 ? 1 : maxFiles - _currentFiles.length,
      );

      // SOLUCIÓN: Si no se seleccionaron archivos, volver al estado anterior
      if (files.isEmpty) {
        emit(FileUploadSuccess(files: _currentFiles));
        debugPrint('📁 No files selected, returning to previous state');
        return;
      }

      if (files.isNotEmpty) {
        final validFiles = <UploadedFile>[];

        for (final file in files) {
          final validation = _validateFile(file);
          if (validation == null) {
            validFiles.add(file);
          } else {
            emit(
              FileUploadError(errorMessage: validation, files: _currentFiles),
            );
            return;
          }
        }

        // SOLUCIÓN: Si maxFiles = 1, reemplazar el archivo existente
        final allFiles =
            maxFiles == 1 ? validFiles : [..._currentFiles, ...validFiles];

        emit(
          FileUploadSuccess(
            files: allFiles,
            message:
                maxFiles == 1 && _currentFiles.isNotEmpty
                    ? 'Archivo reemplazado correctamente'
                    : validFiles.length == 1
                    ? 'Archivo "${validFiles.first.name}" agregado'
                    : '${validFiles.length} archivos agregados',
          ),
        );

        debugPrint('✅ Files processed: ${validFiles.length}');
      }
    } catch (e) {
      debugPrint('❌ Error picking files: $e');
      emit(
        FileUploadError(
          errorMessage: 'Error al seleccionar archivos: ${e.toString()}',
          files: _currentFiles,
        ),
      );
    }
  }

  Future<void> _onProcessDroppedFiles(
    ProcessDroppedFilesEvent event,
    Emitter<FileUploadState> emit,
  ) async {
    try {
      emit(const FileUploadLoading());

      final files = await _fileService.processDroppedFiles(event.files);

      if (files.isNotEmpty) {
        final validFiles = <UploadedFile>[];

        for (final file in files) {
          final validation = _validateFile(file);
          if (validation == null) {
            validFiles.add(file);
          } else {
            emit(
              FileUploadError(errorMessage: validation, files: _currentFiles),
            );
            return;
          }
        }

        final allFiles = [..._currentFiles, ...validFiles];
        emit(
          FileUploadSuccess(
            files: allFiles,
            message: 'Archivos arrastrados agregados correctamente',
          ),
        );

        debugPrint('✅ Files added via drag & drop: ${validFiles.length}');
      } else {
        emit(FileUploadSuccess(files: _currentFiles));
      }
    } catch (e) {
      debugPrint('❌ Error processing dropped files: $e');
      emit(
        FileUploadError(
          errorMessage: 'Error al procesar archivos arrastrados',
          files: _currentFiles,
        ),
      );
    }
  }

  void _onAddFiles(AddFilesEvent event, Emitter<FileUploadState> emit) {
    final allFiles = [..._currentFiles, ...event.files];
    emit(FileUploadSuccess(files: allFiles));
  }

  void _onRemoveFile(RemoveFileEvent event, Emitter<FileUploadState> emit) {
    final files = List<UploadedFile>.from(_currentFiles);
    if (event.index >= 0 && event.index < files.length) {
      final removedFile = files.removeAt(event.index);
      emit(
        FileUploadSuccess(
          files: files,
          message: 'Archivo "${removedFile.name}" eliminado',
        ),
      );
      debugPrint('🗑️ File removed: ${removedFile.name}');
    }
  }

  void _onClearFiles(ClearFilesEvent event, Emitter<FileUploadState> emit) {
    emit(
      const FileUploadSuccess(
        files: [],
        message: 'Todos los archivos eliminados',
      ),
    );
  }

  String? _validateFile(UploadedFile file) {
    if (maxFiles == 1 && _currentFiles.isNotEmpty) {
      // Si ya hay un archivo y el máximo es 1, reemplazar
      return null; // Permitir reemplazo
    }

    // Validar extensión
    if (!file.name.contains('.')) {
      return 'El archivo debe tener una extensión válida';
    }

    final extension = file.name.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      return 'Tipo de archivo no permitido: .$extension\nPermitidos: ${allowedExtensions.join(', ')}';
    }

    // Validar tamaño
    final maxSizeBytes = maxFileSizeMB * 1024 * 1024;
    if (file.size > maxSizeBytes) {
      final sizeMB = (file.size / (1024 * 1024)).toStringAsFixed(1);
      return 'El archivo es muy grande ($sizeMB MB).\nMáximo permitido: ${maxFileSizeMB}MB';
    }

    // Validar cantidad máxima (solo si no es reemplazo)
    if (maxFiles > 1 && _currentFiles.length >= maxFiles) {
      return 'Máximo $maxFiles archivos permitidos';
    }

    return null;
  }
}
