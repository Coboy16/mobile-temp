part of 'permission_request_bloc.dart';

sealed class PermissionRequestState extends Equatable {
  const PermissionRequestState();

  @override
  List<Object> get props => [];
}

class PermissionRequestInitial extends PermissionRequestState {
  const PermissionRequestInitial();
}

class PermissionRequestLoading extends PermissionRequestState {
  const PermissionRequestLoading();
}

class PermissionRequestSuccess extends PermissionRequestState {
  final RequestFormData requestData;
  final String message;

  const PermissionRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de permiso enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'PermissionRequestSuccess { requestData: $requestData, message: $message }';
}

class PermissionRequestFailure extends PermissionRequestState {
  final String errorMessage;

  const PermissionRequestFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() =>
      'PermissionRequestFailure { errorMessage: $errorMessage }';
}
