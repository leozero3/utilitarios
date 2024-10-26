abstract class PasswordRepository {
  Future<void> addPassword(String name, String description, String password);
  Future<List<Map<String, dynamic>>> getPasswords();
  Future<String> getPasswordById(int id);
  Future<void> updatePassword(
      int id, String name, String description, String password);
  Future<void> deletePassword(int id);
}
