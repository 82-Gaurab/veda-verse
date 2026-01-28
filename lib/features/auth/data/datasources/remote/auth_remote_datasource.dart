import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/api/api_client.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/core/services/storage/token_service.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';
import 'package:vedaverse/features/auth/data/datasources/auth_datasource.dart';
import 'package:vedaverse/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  final tokenService = ref.read(tokenServiceProvider);

  return AuthRemoteDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
    tokenService: tokenService,
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {"email": email, "password": password},
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);
      // info: Save user session
      await _userSessionService.saveUserSession(
        userId: user.authId!,
        email: user.email,
        username: user.username,
        firstName: user.firstName,
        lastName: user.lastName,
      );
      // info: save token
      final token = response.data["token"] as String?;
      await _tokenService.saveToken(token!);
      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    if (response.data["success"] == true) {
      final data = response.data["data"] as Map<String, dynamic>;
      final resistedUser = AuthApiModel.fromJson(data);
      return resistedUser;
    }

    return user;
  }

  @override
  Future<AuthApiModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<String> uploadImage(File image) async {
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      "profilePicture": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    // get token from token services
    final token = _tokenService.getToken();

    final response = await _apiClient.uploadFile(
      ApiEndpoints.userUploadPhoto,
      formData: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response.data["data"];
  }

  @override
  Future<bool> updateUser(AuthApiModel user) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateUser,
      data: user.toJson(),
    );

    return response.data["success"];
  }
}
