import 'package:equatable/equatable.dart';

class SessionStatusEntity extends Equatable {
  final bool hasActiveSession;

  const SessionStatusEntity({required this.hasActiveSession});

  @override
  List<Object?> get props => [hasActiveSession];
}
