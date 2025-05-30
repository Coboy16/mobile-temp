part of 'permission_request_bloc.dart';

sealed class PermissionRequestEvent extends Equatable {
  const PermissionRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitPermissionRequest extends PermissionRequestEvent {
  final RequestFormData requestData;

  const SubmitPermissionRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() => 'SubmitPermissionRequest { requestData: $requestData }';
}

class ResetPermissionRequest extends PermissionRequestEvent {
  const ResetPermissionRequest();
}
