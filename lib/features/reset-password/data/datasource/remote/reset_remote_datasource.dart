import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/api/api_client.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/features/reset-password/data/datasource/reset_datasource.dart';

final resetPasswordRemoteDatasourceProvider = Provider<IResetRemoteDatasource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  return ResetRemoteDatasource(apiClient: apiClient);
});

class ResetRemoteDatasource implements IResetRemoteDatasource {
  final ApiClient _apiClient;

  ResetRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;
  @override
  Future<bool> resetPassword(String email, String newPassword) async {
    final response = await _apiClient.post(
      ApiEndpoints.userPasswordReset,
      data: {"email": email, "newPassword": newPassword},
    );

    return response.data["success"];
  }
}
