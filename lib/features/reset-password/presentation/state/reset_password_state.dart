import 'package:equatable/equatable.dart';

enum ResetStatus { initial, loading, success, error }

class ResetPasswordState extends Equatable {
  final ResetStatus status;
  final String? otp;
  final String? errorMessage;

  const ResetPasswordState({
    this.status = ResetStatus.initial,
    this.errorMessage,
    this.otp,
  });

  ResetPasswordState copyWith({
    ResetStatus? status,
    String? errorMessage,
    String? otp,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      otp: otp ?? this.otp,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
