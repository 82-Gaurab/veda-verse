import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserUsecaseParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;
  final String profilePicture;

  const UpdateUserUsecaseParams({
    required this.firstName,
    required this.email,
    required this.username,
    required this.password,
    required this.lastName,
    required this.profilePicture,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    username,
    password,
    profilePicture,
  ];
}

class UpdateUserUsecase
    implements UseCaseWithParams<bool, UpdateUserUsecaseParams> {
  final IAuthRepository _authRepository;

  UpdateUserUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, bool>> call(UpdateUserUsecaseParams params) {
    final entity = AuthEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      username: params.username,
      profilePicture: params.profilePicture,
    );

    return _authRepository.updateUser(entity);
  }
}
