import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, bool>> updateUser(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  // image upload
  Future<Either<Failure, String>> uploadImage(File image);
  Future<Either<Failure, bool>> logout();
}
