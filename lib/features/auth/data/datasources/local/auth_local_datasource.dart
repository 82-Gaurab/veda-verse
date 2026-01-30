import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/core/services/hive/hive_service.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';
import 'package:vedaverse/features/auth/data/datasources/auth_datasource.dart';
import 'package:vedaverse/features/auth/data/models/auth_hive_model.dart';

final authLocalDatasourceProvider = Provider<IAuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);

  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);

      if (user != null && user.authId != null) {
        // Save user session to SharedPreferences : Pachi app restart vayo vani pani user logged in rahos
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          email: user.email,
          firstName: user.firstName,
          username: user.username,
          profilePicture: user.profilePicture,
          lastName: user.lastName,
        );
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _userSessionService.clearSession();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      await _hiveService.registerUser(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String authId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) {
    // TODO: implement getUserByEmail
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<bool> updateUser(AuthHiveModel user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
