part of 'medical_leave_request_bloc.dart';

sealed class MedicalLeaveRequestEvent extends Equatable {
  const MedicalLeaveRequestEvent();

  @override
  List<Object> get props => [];
}

class SubmitMedicalLeaveRequest extends MedicalLeaveRequestEvent {
  final RequestFormData requestData;

  const SubmitMedicalLeaveRequest(this.requestData);

  @override
  List<Object> get props => [requestData];

  @override
  String toString() =>
      'SubmitMedicalLeaveRequest { requestData: $requestData }';
}

class ResetMedicalLeaveRequest extends MedicalLeaveRequestEvent {
  const ResetMedicalLeaveRequest();
}
