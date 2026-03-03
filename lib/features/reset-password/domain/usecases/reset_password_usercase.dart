import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/reset-password/data/repository/reset_password_repository.dart';
import 'package:vedaverse/features/reset-password/domain/repository/reset_password_repository.dart';

final resetPasswordUseCaseProvider = Provider<ResetPasswordUserCase>((ref) {
  final resetPasswordRepository = ref.read(resetPasswordRepositoryProvider);
  return ResetPasswordUserCase(
    resetPasswordRepository: resetPasswordRepository,
  );
});

class ResetPasswordUserCaseParams extends Equatable {
  final String email;
  final String newPassword;

  const ResetPasswordUserCaseParams({
    required this.email,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, newPassword];
}

class ResetPasswordUserCase
    implements UseCaseWithParams<bool, ResetPasswordUserCaseParams> {
  final IResetPasswordRepository _resetPasswordRepository;

  ResetPasswordUserCase({
    required IResetPasswordRepository resetPasswordRepository,
  }) : _resetPasswordRepository = resetPasswordRepository;
  @override
  Future<Either<Failure, bool>> call(ResetPasswordUserCaseParams params) {
    return _resetPasswordRepository.resetPassword(
      params.email,
      params.newPassword,
    );
  }
}
