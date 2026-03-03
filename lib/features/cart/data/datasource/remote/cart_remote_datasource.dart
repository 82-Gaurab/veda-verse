import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/api/api_client.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/core/services/storage/token_service.dart';
import 'package:vedaverse/features/cart/data/datasource/cart_datasource.dart';
import 'package:vedaverse/features/cart/data/models/cart_api_model.dart';

final cartRemoteDatasourceProvider = Provider<ICartRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return CartRemoteDatasource(apiClient: apiClient, tokenService: tokenService);
});

class CartRemoteDatasource implements ICartRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  const CartRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<bool> createCart(CartApiModel cart) async {
    final token = _tokenService.getToken();
    final data = cart.toJson();

    final response = await _apiClient.put(
      ApiEndpoints.carts,
      data: data,
      option: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response.data["success"];
  }

  @override
  Future<List<CartApiModel>> getMyCart() async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.userInfo,
      option: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final cart = response.data["data"]["cart"] as List;

    return cart.map((json) => CartApiModel.fromJson(json)).toList();
  }
}
