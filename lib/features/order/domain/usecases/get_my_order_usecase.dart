import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/order/data/repository/order_repository.dart';
import 'package:vedaverse/features/order/domain/entities/order_entity.dart';
import 'package:vedaverse/features/order/domain/repository/order_repository.dart';

final getMyOrdersUsecaseProvider = Provider<GetMyOrdersUsecase>((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return GetMyOrdersUsecase(repository: repository);
});

class GetMyOrdersUsecase implements UseCaseWithoutParams {
  final IOrderRepository _repository;

  GetMyOrdersUsecase({required IOrderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<OrderEntity>>> call() {
    return _repository.getMyOrders();
  }
}
