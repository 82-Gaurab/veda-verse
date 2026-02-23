import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/auth/data/repositories/auth_repository.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';

final sendOtpRequestUsecaseProvider = Provider<SendOtpRequestUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SendOtpRequestUsecase(authRepository: authRepository);
});

class SendOtpRequestUsecaseParams extends Equatable {
  final String email;
  const SendOtpRequestUsecaseParams({required this.email});

  @override
  List<Object?> get props => [email];
}

class SendOtpRequestUsecase
    implements UseCaseWithParams<String, SendOtpRequestUsecaseParams> {
  final IAuthRepository _authRepository;

  SendOtpRequestUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, String>> call(SendOtpRequestUsecaseParams params) {
    return _authRepository.sendOTPRequest(params.email);
  }
}
