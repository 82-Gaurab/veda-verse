import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/error/failures.dart';
import 'package:vedaverse/core/usecases/app_usecase.dart';
import 'package:vedaverse/features/order/data/repository/order_repository.dart';
import 'package:vedaverse/features/order/domain/repository/order_repository.dart';

final payOrderUsecaseProvider = Provider<PayOrderUsecase>((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return PayOrderUsecase(repository: repository);
});

class PayOrderUsecaseParams extends Equatable {
  final String orderId;

  const PayOrderUsecaseParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class PayOrderUsecase
    implements UseCaseWithParams<bool, PayOrderUsecaseParams> {
  final IOrderRepository _repository;

  PayOrderUsecase({required IOrderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(PayOrderUsecaseParams params) {
    return _repository.payOrder(params.orderId);
  }
}
