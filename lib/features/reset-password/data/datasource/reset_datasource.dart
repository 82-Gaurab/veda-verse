abstract interface class IResetRemoteDatasource {
  Future<bool> resetPassword(String email, String newPassword);
}
