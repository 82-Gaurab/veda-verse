import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/reset-password/data/repository/reset_password_repository.dart';
import 'package:vedaverse/features/reset-password/domain/repository/reset_password_repository.dart';

final sendOtpRequestUsecaseProvider = Provider<SendOtpRequestUsecase>((ref) {
  final resetPasswordRepository = ref.watch(resetPasswordRepositoryProvider);
  return SendOtpRequestUsecase(
    resetPasswordRepository: resetPasswordRepository,
  );
});

class SendOtpRequestUsecaseParams extends Equatable {
  final String email;
  const SendOtpRequestUsecaseParams({required this.email});

  @override
  List<Object?> get props => [email];
}

class SendOtpRequestUsecase
    implements UseCaseWithParams<String, SendOtpRequestUsecaseParams> {
  final IResetPasswordRepository _resetPasswordRepository;

  SendOtpRequestUsecase({
    required IResetPasswordRepository resetPasswordRepository,
  }) : _resetPasswordRepository = resetPasswordRepository;
  @override
  Future<Either<Failure, String>> call(SendOtpRequestUsecaseParams params) {
    return _resetPasswordRepository.sendOTPRequest(params.email);
  }
}
