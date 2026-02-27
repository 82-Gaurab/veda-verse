import 'package:vedaverse/features/genre/data/model/genre_hive_model.dart';
import 'package:vedaverse/features/order/data/model/order_api_model.dart';

abstract interface class IOrderLocalDatasource {
  Future<List<GenreHiveModel>> getMyOrders();
  Future<bool> createOrder(GenreHiveModel genre);
}

abstract interface class IOrderRemoteDatasource {
  Future<List<OrderApiModel>> getMyOrders();
  Future<bool> createOrder();
}
