part of 'file_upload_bloc.dart';

sealed class FileUploadEvent extends Equatable {
  const FileUploadEvent();

  @override
  List<Object> get props => [];
}

class AddFilesEvent extends FileUploadEvent {
  final List<UploadedFile> files;

  const AddFilesEvent(this.files);

  @override
  List<Object> get props => [files];
}

class RemoveFileEvent extends FileUploadEvent {
  final int index;

  const RemoveFileEvent(this.index);

  @override
  List<Object> get props => [index];
}

class ClearFilesEvent extends FileUploadEvent {
  const ClearFilesEvent();
}

class TriggerFilePickerEvent extends FileUploadEvent {
  const TriggerFilePickerEvent();
}

class ProcessDroppedFilesEvent extends FileUploadEvent {
  final List<dynamic> files;

  const ProcessDroppedFilesEvent(this.files);

  @override
  List<Object> get props => [files];
}
