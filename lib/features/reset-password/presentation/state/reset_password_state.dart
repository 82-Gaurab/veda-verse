import 'package:equatable/equatable.dart';

enum ResetStatus { initial, loading, success, error }

class ResetPasswordState extends Equatable {
  final ResetStatus status;
  final String? errorMessage;

  const ResetPasswordState({
    this.status = ResetStatus.initial,
    this.errorMessage,
  });

  ResetPasswordState copyWith({ResetStatus? status, String? errorMessage}) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
