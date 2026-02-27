import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/api/api_client.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/core/services/storage/token_service.dart';
import 'package:vedaverse/features/order/data/datasources/order_datasource.dart';
import 'package:vedaverse/features/order/data/model/order_api_model.dart';

final orderRemoteDatasourceProvider = Provider<IOrderRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);

  return OrderRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
  );
});

class OrderRemoteDatasource implements IOrderRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  OrderRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<List<OrderApiModel>> getMyOrders() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.myOrders,
      option: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final data = response.data["data"] as List;

    return data.map((e) => OrderApiModel.fromJson(e)).toList();
  }

  @override
  Future<bool> createOrder() {
    // TODO: implement createOrder
    throw UnimplementedError();
  }
}
