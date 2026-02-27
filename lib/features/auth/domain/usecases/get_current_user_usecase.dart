import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/auth/data/repositories/auth_repository.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';

final getMyInfoUsecaseProvider = Provider<GetMyInfoUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetMyInfoUsecase(authRepository: authRepository);
});

class GetMyInfoUsecase implements UseCaseWithoutParams {
  final IAuthRepository _authRepository;

  GetMyInfoUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call() {
    return _authRepository.getCurrentUser();
  }
}
