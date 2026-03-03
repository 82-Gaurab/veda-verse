import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/services/connectivity/network_info.dart';
import 'package:vedaverse/features/cart/data/datasource/cart_datasource.dart';
import 'package:vedaverse/features/cart/data/datasource/local/cart_local_datasource.dart';
import 'package:vedaverse/features/cart/data/datasource/remote/cart_remote_datasource.dart';
import 'package:vedaverse/features/cart/data/models/cart_api_model.dart';
import 'package:vedaverse/features/cart/data/models/cart_hive_model.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';
import 'package:vedaverse/features/cart/domain/repository/cart_repository.dart';

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  final cartRemoteDatasource = ref.read(cartRemoteDatasourceProvider);
  final cartLocalDatasource = ref.read(cartLocalDatasourceProvider);
  final info = ref.read(networkInfoProvider);
  return CartRepository(
    cartRemoteDatasource: cartRemoteDatasource,
    cartLocalDatasource: cartLocalDatasource,
    networkInfo: info,
  );
});

class CartRepository implements ICartRepository {
  final ICartRemoteDatasource _cartRemoteDatasource;
  final ICartLocalDatasource _cartLocalDatasource;
  final NetworkInfo _networkInfo;

  const CartRepository({
    required ICartRemoteDatasource cartRemoteDatasource,
    required ICartLocalDatasource cartLocalDatasource,
    required NetworkInfo networkInfo,
  }) : _cartRemoteDatasource = cartRemoteDatasource,
       _cartLocalDatasource = cartLocalDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createCart(CartEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = CartApiModel.fromEntity(entity);
        final response = await _cartRemoteDatasource.createCart(model);
        return Right(response);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? "Cart creation Failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = CartHiveModel.fromEntity(entity);
        await _cartLocalDatasource.addCartItem(model);
        return Right(true);
      } catch (e) {
        return Left(LocalDataBaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<CartEntity>>> getMyCart() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _cartRemoteDatasource.getMyCart();
        final entity = CartApiModel.toEntityList(response);
        return Right(entity);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? "Fetching cart Failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      final cartItems = _cartLocalDatasource.getAllCartItems();
      final result = cartItems.map((e) => e.toEntity()).toList();
      return Right(result);
    }
  }
}
