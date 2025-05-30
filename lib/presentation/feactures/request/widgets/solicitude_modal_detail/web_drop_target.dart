import 'package:flutter/material.dart';
import 'dart:html' as html;

class WebDropTarget extends StatefulWidget {
  final Widget child;
  final VoidCallback onDragEnter;
  final VoidCallback onDragLeave;
  final Function(List<html.File>) onFilesDropped;

  const WebDropTarget({
    super.key,
    required this.child,
    required this.onDragEnter,
    required this.onDragLeave,
    required this.onFilesDropped,
  });

  @override
  WebDropTargetState createState() => WebDropTargetState();
}

class WebDropTargetState extends State<WebDropTarget> {
  bool _isDragOver = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupDropEvents();
    });
  }

  void _setupDropEvents() {
    // Verificar que el widget esté montado
    final element = context.findRenderObject() as RenderBox?;
    if (element != null) {
      _setupGlobalDropEvents();
    }
  }

  void _setupGlobalDropEvents() {
    // Configurar eventos globales de drag & drop
    html.document.addEventListener('dragover', _handleDragOver);
    html.document.addEventListener('dragenter', _handleDragEnter);
    html.document.addEventListener('dragleave', _handleDragLeave);
    html.document.addEventListener('drop', _handleDrop);

    debugPrint('🎯 Drag & Drop events configured');
  }

  void _handleDragOver(html.Event event) {
    event.preventDefault();

    // SOLUCIÓN: Verificar que el evento sea del tipo correcto antes de hacer cast
    if (event is html.MouseEvent) {
      // Intentar acceder a dataTransfer si está disponible
      final dynamic dragEvent = event;
      try {
        // Acceso dinámico a dataTransfer
        final dataTransfer = dragEvent.dataTransfer;
        if (dataTransfer != null) {
          dataTransfer.dropEffect = 'copy';
        }
      } catch (e) {
        // Si no hay dataTransfer, continuar sin él
        debugPrint('⚠️ DataTransfer not available: $e');
      }

      if (!_isDragOver) {
        setState(() => _isDragOver = true);
        widget.onDragEnter();
        debugPrint('🎯 Drag over detected');
      }
    }
  }

  void _handleDragEnter(html.Event event) {
    event.preventDefault();
    debugPrint('🎯 Drag enter detected');
  }

  void _handleDragLeave(html.Event event) {
    // SOLUCIÓN: Solo activar si realmente salimos del área
    if (event is html.MouseEvent) {
      final mouseEvent = event;
      final rect = html.document.documentElement!.getBoundingClientRect();

      if (mouseEvent.client.x <= 0 ||
          mouseEvent.client.y <= 0 ||
          mouseEvent.client.x >= rect.width ||
          mouseEvent.client.y >= rect.height) {
        if (_isDragOver) {
          setState(() => _isDragOver = false);
          widget.onDragLeave();
          debugPrint('🎯 Drag leave detected');
        }
      }
    }
  }

  void _handleDrop(html.Event event) {
    event.preventDefault();

    setState(() => _isDragOver = false);

    // SOLUCIÓN: Acceso dinámico a los archivos del evento
    try {
      final dynamic dragEvent = event;
      final dataTransfer = dragEvent.dataTransfer;

      if (dataTransfer?.files?.isNotEmpty == true) {
        final files = <html.File>[];
        final fileList = dataTransfer.files;

        // Convertir FileList a List<html.File>
        for (int i = 0; i < fileList.length; i++) {
          files.add(fileList.item(i)!);
        }

        debugPrint('🎯 Files dropped: ${files.length}');
        widget.onFilesDropped(files);
      }
    } catch (e) {
      debugPrint('❌ Error processing dropped files: $e');
    }
  }

  @override
  void dispose() {
    // Limpiar event listeners
    html.document.removeEventListener('dragover', _handleDragOver);
    html.document.removeEventListener('dragenter', _handleDragEnter);
    html.document.removeEventListener('dragleave', _handleDragLeave);
    html.document.removeEventListener('drop', _handleDrop);
    debugPrint('🎯 Drag & Drop events cleaned up');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
