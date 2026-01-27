import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';

final tokenServiceProvider = Provider<TokenService>((ref) {
  final sharedPreferences = ref.read(sharedPreferenceProvider);
  return TokenService(sharedPreference: sharedPreferences);
});

class TokenService {
  final SharedPreferences _sharedPreferences;
  static const String _tokenKey = "auth_token";

  TokenService({required SharedPreferences sharedPreference})
    : _sharedPreferences = sharedPreference;

  // info: save token
  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString(_tokenKey, token);
  }

  // info: get token
  String? getToken() {
    return _sharedPreferences.getString(_tokenKey);
  }

  // info: remove token
  Future<void> removeToken() async {
    await _sharedPreferences.remove(_tokenKey);
  }
}
