import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/services/connectivity/network_info.dart';
import 'package:vedaverse/features/reset-password/data/datasource/remote/reset_remote_datasource.dart';
import 'package:vedaverse/features/reset-password/data/datasource/reset_datasource.dart';
import 'package:vedaverse/features/reset-password/domain/repository/reset_password_repository.dart';

final resetPasswordRepositoryProvider = Provider<IResetPasswordRepository>((
  ref,
) {
  final networkInfo = ref.read(networkInfoProvider);
  final resetRemoteDatasource = ref.read(resetPasswordRemoteDatasourceProvider);
  return ResetPasswordRepository(
    resetRemoteDatasource: resetRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ResetPasswordRepository implements IResetPasswordRepository {
  final NetworkInfo _networkInfo;
  final IResetRemoteDatasource _resetRemoteDatasource;

  ResetPasswordRepository({
    required IResetRemoteDatasource resetRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _resetRemoteDatasource = resetRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> resetPassword(
    String email,
    String newPassword,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _resetRemoteDatasource.resetPassword(
          email,
          newPassword,
        );

        return Right(response);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data["message"] ?? "Reset Password Failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }
    return Left(ApiFailure(message: "No internet Connection"));
  }
}
