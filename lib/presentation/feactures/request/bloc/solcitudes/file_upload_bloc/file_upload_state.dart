part of 'file_upload_bloc.dart';

sealed class FileUploadState extends Equatable {
  const FileUploadState();

  @override
  List<Object> get props => [];
}

final class FileUploadInitial extends FileUploadState {}

class FileUploadLoading extends FileUploadState {
  const FileUploadLoading();
}

class FileUploadSuccess extends FileUploadState {
  final List<UploadedFile> files;
  final String? message;

  const FileUploadSuccess({required this.files, this.message});

  @override
  List<Object> get props => [files, message ?? ''];
}

class FileUploadError extends FileUploadState {
  final String errorMessage;
  final List<UploadedFile> files;

  const FileUploadError({required this.errorMessage, required this.files});

  @override
  List<Object> get props => [errorMessage, files];
}
