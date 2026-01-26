import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/auth/data/repositories/auth_repository.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';

// Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecaseParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;
  final String confirmPassword;

  const RegisterUsecaseParams({
    required this.firstName,
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.lastName,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, username, password];
}

class RegisterUsecase
    implements UseCaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      firstName: params.firstName,
      email: params.email,
      username: params.username,
      password: params.password,
      confirmPassword: params.confirmPassword,
      lastName: params.lastName,
    );
    return _authRepository.register(entity);
  }
}
