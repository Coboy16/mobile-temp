part of 'medical_leave_request_bloc.dart';

sealed class MedicalLeaveRequestState extends Equatable {
  const MedicalLeaveRequestState();

  @override
  List<Object> get props => [];
}

class MedicalLeaveRequestInitial extends MedicalLeaveRequestState {
  const MedicalLeaveRequestInitial();
}

class MedicalLeaveRequestLoading extends MedicalLeaveRequestState {
  const MedicalLeaveRequestLoading();
}

class MedicalLeaveRequestSuccess extends MedicalLeaveRequestState {
  final RequestFormData requestData;
  final String message;

  const MedicalLeaveRequestSuccess({
    required this.requestData,
    this.message = 'Solicitud de licencia médica enviada correctamente',
  });

  @override
  List<Object> get props => [requestData, message];

  @override
  String toString() =>
      'MedicalLeaveRequestSuccess { requestData: $requestData, message: $message }';
}

class MedicalLeaveRequestFailure extends MedicalLeaveRequestState {
  final String errorMessage;

  const MedicalLeaveRequestFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() =>
      'MedicalLeaveRequestFailure { errorMessage: $errorMessage }';
}
