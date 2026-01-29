import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/auth/data/repositories/auth_repository.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';

final updateUserUsecaseProvider = Provider<UpdateUserUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UpdateUserUsecase(authRepository: authRepository);
});

class UpdateUserUsecaseParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final File profilePicture;

  const UpdateUserUsecaseParams({
    required this.firstName,
    required this.email,
    required this.username,
    required this.lastName,
    required this.profilePicture,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    username,
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
      profilePicture: params.profilePicture.path,
    );

    return _authRepository.updateUser(entity, params.profilePicture);
  }
}
