import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Note: Provider for shared preference
final sharedPreferenceProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    "Shared pref main.dart bata implement garne ho. Timi dukha basa ma dinxu",
  );
});

//Note: Provider for user Session service
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(
    sharedPreference: ref.read(sharedPreferenceProvider),
  );
});

class UserSessionService {
  final SharedPreferences _sharedPreferences;

  UserSessionService({required SharedPreferences sharedPreference})
    : _sharedPreferences = sharedPreference;

  // keys for storing data
  static const String _keysIsLoggedIn = "is_logged_in";
  static const String _keyUserId = "user_id";
  static const String _keyUserEmail = "user_email";
  static const String _keyUsername = "username";
  static const String _keyUserFirstName = "user_first_name";
  static const String _keyUserLastName = "user_last_name";
  static const String _keyUserProfileImage = "user_profile_image";

  // Info: save user session data
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String username,
    required String firstName,
    required String lastName,
    String? profilePicture,
  }) async {
    await _sharedPreferences.setBool(_keysIsLoggedIn, true);
    await _sharedPreferences.setString(_keyUserId, userId);
    await _sharedPreferences.setString(_keyUserEmail, email);
    await _sharedPreferences.setString(_keyUsername, username);
    await _sharedPreferences.setString(_keyUserFirstName, firstName);
    await _sharedPreferences.setString(_keyUserLastName, lastName);
    // if (batchId != null) {
    //   await _sharedPreferences.setString(_keyUserBatchId, batchId);
    // }
    if (profilePicture != null) {
      await _sharedPreferences.setString(_keyUserProfileImage, profilePicture);
    }
  }

  //Info: Clear user session
  Future<void> clearSession() async {
    await _sharedPreferences.remove(_keysIsLoggedIn);
    await _sharedPreferences.remove(_keyUserId);
    await _sharedPreferences.remove(_keyUserEmail);
    await _sharedPreferences.remove(_keyUsername);
    await _sharedPreferences.remove(_keyUserFirstName);
    await _sharedPreferences.remove(_keyUserLastName);
    await _sharedPreferences.remove(_keyUserProfileImage);
  }

  // Info: getter
  bool isLoggedIn() {
    return _sharedPreferences.getBool(_keysIsLoggedIn) ?? false;
  }

  String? getUserId() {
    return _sharedPreferences.getString(_keyUserId);
  }

  String? getUserEmail() {
    return _sharedPreferences.getString(_keyUserEmail);
  }

  String? getUsername() {
    return _sharedPreferences.getString(_keyUsername);
  }

  String? getUserFirstName() {
    return _sharedPreferences.getString(_keyUserFirstName);
  }

  String? getUserLastName() {
    return _sharedPreferences.getString(_keyUserLastName);
  }

  String? getUserProfileImage() {
    return _sharedPreferences.getString(_keyUserProfileImage);
  }
}
