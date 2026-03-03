import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/services/connectivity/network_info.dart';
import 'package:vedaverse/features/order/data/datasources/order_datasource.dart';
import 'package:vedaverse/features/order/data/datasources/remote/order_remote_datasource.dart';
import 'package:vedaverse/features/order/data/model/order_api_model.dart';
import 'package:vedaverse/features/order/domain/entities/order_entity.dart';
import 'package:vedaverse/features/order/domain/repository/order_repository.dart';

final orderRepositoryProvider = Provider<IOrderRepository>((ref) {
  final remoteDatasource = ref.read(orderRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return OrderRepository(
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class OrderRepository implements IOrderRepository {
  final IOrderRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  OrderRepository({
    required IOrderRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDatasource.getMyOrders();
        final entities = OrderApiModel.toEntityList(models);
        return Right(entities);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Failed to fetch orders",
          ),
        );
      }
    } else {
      return Left(ApiFailure(message: "No Internet"));
    }
  }

  @override
  Future<Either<Failure, bool>> createOrder() async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDatasource.createOrder();
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Failed to create order",
          ),
        );
      }
    } else {
      return Left(
        ApiFailure(message: "Internet connection is needed to create order"),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> payOrder(String orderId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _remoteDatasource.pay(orderId);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Failed to pay order",
          ),
        );
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }
}
