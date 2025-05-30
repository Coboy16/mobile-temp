import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotted/flutter_dotted.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Solo importar dart:html en web
import 'dart:html' as html;

import '/presentation/feactures/request/bloc/bloc.dart';
import '/data/data.dart';

class DocumentUploaderWeb extends StatefulWidget {
  final Function(List<UploadedFile>)? onFilesChanged;
  final List<String> allowedExtensions;
  final int maxFileSizeMB;
  final int maxFiles;
  final bool allowMultiple;

  const DocumentUploaderWeb({
    super.key,
    this.onFilesChanged,
    this.allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
    this.maxFileSizeMB = 5,
    this.maxFiles = 1,
    this.allowMultiple = false,
  });

  @override
  State<DocumentUploaderWeb> createState() => _DocumentUploaderWebState();
}

class _DocumentUploaderWebState extends State<DocumentUploaderWeb> {
  bool _isHovering = false;
  bool _isDragOver = false;
  StreamSubscription? _dragOverSubscription;
  StreamSubscription? _dropSubscription;
  StreamSubscription? _dragLeaveSubscription;

  @override
  void initState() {
    super.initState();
    _setupWebDragAndDrop();
  }

  @override
  void dispose() {
    _dragOverSubscription?.cancel();
    _dropSubscription?.cancel();
    _dragLeaveSubscription?.cancel();
    super.dispose();
  }

  void _setupWebDragAndDrop() {
    try {
      debugPrint('🌐 Setting up enhanced web drag and drop');

      // Prevenir comportamiento por defecto y configurar feedback
      _dragOverSubscription = html.document.onDragOver.listen((event) {
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';

        // Solo activar drag over si realmente hay archivos
        if (event.dataTransfer.files?.isNotEmpty == true ||
            (event.dataTransfer.items?.length ?? 0) > 0) {
          if (!_isDragOver) {
            setState(() {
              debugPrint('🎯 Drag over activated - files detected');
              _isDragOver = true;
            });
          }
        }
      });

      // Manejar el drop
      _dropSubscription = html.document.onDrop.listen((event) {
        event.preventDefault();
        event.stopPropagation();

        debugPrint('🎯 Drop event triggered');

        // Resetear estado visual
        setState(() => _isDragOver = false);

        // Procesar archivos
        if (event.dataTransfer.files?.isNotEmpty == true) {
          final files = event.dataTransfer.files!;
          debugPrint('🎯 Files dropped: ${files.length}');

          final fileList = <html.File>[];
          for (int i = 0; i < files.length; i++) {
            fileList.add(files[i]);
          }

          _handleDroppedFiles(fileList);
        } else {
          debugPrint('⚠️ Drop event but no files found');
        }
      });

      // Manejar drag leave
      _dragLeaveSubscription = html.document.onDragLeave.listen((event) {
        // Usar timer para evitar flicker cuando se mueve entre elementos
        Timer(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              debugPrint('🎯 Drag leave detected');
              _isDragOver = false;
            });
          }
        });
      });
    } catch (e) {
      debugPrint('⚠️ Error setting up drag and drop: $e');
    }
  }

  void _handleDroppedFiles(List<html.File> files) {
    debugPrint('📁 Processing ${files.length} dropped files');

    try {
      // Verificar que el widget aún esté montado antes de usar el context
      if (!mounted) {
        debugPrint('⚠️ Widget not mounted, skipping file processing');
        return;
      }

      // Usar el BLoC para procesar los archivos
      context.read<FileUploadBloc>().add(ProcessDroppedFilesEvent(files));

      // Mostrar feedback inmediato solo si el widget está montado
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Procesando ${files.length} archivo(s)...'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error handling dropped files: $e');
      // Solo mostrar error si el widget está montado
      if (mounted) {
        _showError('Error al procesar archivos arrastrados');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileUploadBloc, FileUploadState>(
      listener: (context, state) {
        if (state is FileUploadSuccess) {
          widget.onFilesChanged?.call(state.files);
          if (state.message != null) {
            _showSuccess(state.message!);
          }
        } else if (state is FileUploadError) {
          _showError(state.errorMessage);
        }
      },
      child: BlocBuilder<FileUploadBloc, FileUploadState>(
        builder: (context, state) {
          final files = _getFilesFromState(state);
          final isLoading = state is FileUploadLoading;
          final hasFiles = files.isNotEmpty;

          debugPrint(
            '🎨 Widget rebuild - hasFiles: $hasFiles, files: ${files.length}, state: ${state.runtimeType}',
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasFiles) ...[_buildUploadArea(context, isLoading)],
              if (hasFiles) ...[_buildFilesList(context, files)],
            ],
          );
        },
      ),
    );
  }

  List<UploadedFile> _getFilesFromState(FileUploadState state) {
    if (state is FileUploadSuccess) return state.files;
    if (state is FileUploadError) return state.files;
    return [];
  }

  Widget _buildUploadArea(BuildContext context, bool isLoading) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap:
            isLoading
                ? null
                : () {
                  debugPrint('🌐 Web upload area tapped');
                  context.read<FileUploadBloc>().add(
                    const TriggerFilePickerEvent(),
                  );
                },
        child: _buildUploadUI(isLoading),
      ),
    );
  }

  Widget _buildUploadUI(bool isLoading) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      child: FlutterDotted(
        gap: 5,
        strokeWidth: (_isHovering || _isDragOver) ? 1.2 : 0.8,
        color: (_isHovering || _isDragOver) ? Colors.blue : Colors.grey[400]!,
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color:
                (_isHovering || _isDragOver)
                    ? Colors.blue.withOpacity(0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: isLoading ? _buildLoadingWidget() : _buildUploadContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.blue[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Procesando archivo...',
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: (_isHovering || _isDragOver) ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            _isDragOver ? LucideIcons.download : LucideIcons.upload,
            size: 35,
            color:
                (_isHovering || _isDragOver)
                    ? Colors.blue[600]
                    : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color:
                (_isHovering || _isDragOver) ? Colors.blue[800] : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
          child: Text(
            _isDragOver
                ? '🎯 Suelte el archivo aquí'
                : 'Haga clic para subir o arrastre y suelte',
          ),
        ),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 12,
            color:
                (_isHovering || _isDragOver)
                    ? Colors.blue[600]
                    : Colors.grey[500],
          ),
          child: Text(
            '${widget.allowedExtensions.join(', ').toUpperCase()} (máx. ${widget.maxFileSizeMB}MB)',
          ),
        ),
      ],
    );
  }

  Widget _buildFilesList(BuildContext context, List<UploadedFile> files) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Archivo seleccionado (${files.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                context.read<FileUploadBloc>().add(
                  const TriggerFilePickerEvent(),
                );
              },
              icon: const Icon(LucideIcons.pencil, size: 16),
              label: const Text('Cambiar'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[600],
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: files.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _buildFileCard(context, files[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildFileCard(BuildContext context, UploadedFile file, int index) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getFileColor(file),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(_getFileIcon(file), color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      file.sizeFormatted,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getFileColor(file).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        file.extension,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getFileColor(file),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<FileUploadBloc>().add(RemoveFileEvent(index));
            },
            icon: const Icon(LucideIcons.x, size: 16),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              foregroundColor: Colors.red,
              minimumSize: const Size(32, 32),
              padding: const EdgeInsets.all(8),
            ),
            tooltip: 'Eliminar archivo',
          ),
        ],
      ),
    );
  }

  Color _getFileColor(UploadedFile file) {
    if (file.isPDF) return Colors.red;
    if (file.isImage) return Colors.blue;
    return Colors.grey;
  }

  IconData _getFileIcon(UploadedFile file) {
    if (file.isPDF) return LucideIcons.fileText;
    if (file.isImage) return LucideIcons.image;
    return LucideIcons.file;
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
