import 'package:dartz/dartz.dart';
import 'package:vedaverse/core/error/failures.dart';

abstract interface class IResetPasswordRepository {
  Future<Either<Failure, bool>> resetPassword(String email, String newPassword);
}
