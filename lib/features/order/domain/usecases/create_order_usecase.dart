import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/order/data/repository/order_repository.dart';
import 'package:vedaverse/features/order/domain/repository/order_repository.dart';

final createOrderUsecaseProvider = Provider<CreateOrdersUsecase>((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return CreateOrdersUsecase(repository: repository);
});

class CreateOrdersUsecase implements UseCaseWithoutParams {
  final IOrderRepository _repository;

  CreateOrdersUsecase({required IOrderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call() {
    return _repository.createOrder();
  }
}
