import 'package:utilitarios/modules/password_manager/passwords/service/database_service.dart';
import 'package:utilitarios/modules/password_manager/passwords/service/encryption_service.dart';

import 'password_repository.dart';

class ImplPasswordRepository implements PasswordRepository {
  final DatabasePasswordService _databaseService = DatabasePasswordService();
  final EncryptionService _encryptionService = EncryptionService();

  ImplPasswordRepository();

  @override
  Future<void> addPassword(
      String name, String description, String password) async {
    final encryptedPassword = _encryptionService.encryptPassword(password);

    await _databaseService.addPassword(name, description, encryptedPassword);
  }

  @override
  Future<void> deletePassword(int id) async {
    await _databaseService.deletePassword(id);
  }

  @override
  Future<List<Map<String, dynamic>>> getPasswords() async {
    final passwords = await _databaseService.getPasswords();
    return passwords.map((password) {
      // final decryptedPassword =
      //     _encryptionService.decryptPassword(password['password']);
      return {
        'id': password['id'],
        'name': password['name'],
        'description': password['description'],
        // 'password': decryptedPassword,
      };
    }).toList();

    // return await _databaseService.getPasswords();
  }

  @override
  Future<void> updatePassword(
      int id, String name, String description, String password) async {
    final encryptedPassword = _encryptionService.encryptPassword(password);
    await _databaseService.updatePassword(
        id, name, description, encryptedPassword);
  }

  @override
  Future<String> getPasswordById(int id) async {
    final password = await _databaseService.getPasswordById(id);
    final decryptedPassword =
        _encryptionService.decryptPassword(password['password']);
    return decryptedPassword;
  }
}
