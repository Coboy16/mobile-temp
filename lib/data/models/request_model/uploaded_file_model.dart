class UploadedFile {
  final String name;
  final String? path;
  final int size;
  final String type;
  final List<int>? bytes;
  final DateTime uploadedAt;

  UploadedFile({
    required this.name,
    this.path,
    required this.size,
    required this.type,
    this.bytes,
    DateTime? uploadedAt,
  }) : uploadedAt = uploadedAt ?? DateTime.now();

  String get sizeFormatted {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get extension {
    final parts = name.split('.');
    return parts.length > 1 ? parts.last.toUpperCase() : '';
  }

  bool get isPDF => extension == 'PDF';
  bool get isImage => ['JPG', 'JPEG', 'PNG', 'GIF'].contains(extension);
}
