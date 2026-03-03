abstract interface class IResetRemoteDatasource {
  Future<bool> resetPassword(String email, String newPassword);
  Future<String> sendOTPRequest(String email);
}
