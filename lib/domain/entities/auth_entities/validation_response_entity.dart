import 'package:equatable/equatable.dart';

class BlockedInfoEntity extends Equatable {
  final bool state;
  final int minute;

  const BlockedInfoEntity({required this.state, required this.minute});

  @override
  List<Object?> get props => [state, minute];
}

class ValidationResponseEntity extends Equatable {
  final bool isBlocked;
  final int minutesBlocked;

  const ValidationResponseEntity({
    required this.isBlocked,
    required this.minutesBlocked,
  });

  @override
  List<Object?> get props => [isBlocked, minutesBlocked];
}
