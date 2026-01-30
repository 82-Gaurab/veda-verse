import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/auth/data/repositories/auth_repository.dart';
import 'package:vedaverse/features/auth/domain/repositories/auth_repository.dart';

class UploadImageUsecaseParams extends Equatable {
  final File image;
  const UploadImageUsecaseParams({required this.image});
  @override
  List<Object?> get props => [image];
}

final uploadImageUsecaseProvider = Provider<UploadImageUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UploadImageUsecase(iAuthRepository: authRepository);
});

class UploadImageUsecase
    implements UseCaseWithParams<String, UploadImageUsecaseParams> {
  final IAuthRepository _iAuthRepository;
  UploadImageUsecase({required IAuthRepository iAuthRepository})
    : _iAuthRepository = iAuthRepository;

  @override
  Future<Either<Failure, String>> call(UploadImageUsecaseParams params) {
    return _iAuthRepository.uploadImage(params.image);
  }
}
