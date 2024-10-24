import 'package:utilitarios/modules/password_manager/service/database_service.dart';
import 'package:utilitarios/modules/password_manager/service/encryption_service.dart';

import './password_repository.dart';

class ImplPasswordRepository implements PasswordRepository {
  final DatabasePasswordService _databaseService;
  final EncryptionService _encryptionService;

  ImplPasswordRepository(this._databaseService, this._encryptionService);

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
    return await _databaseService.getPasswords();
  }

  @override
  Future<void> updatePassword(
      int id, String name, String description, String password) async {
    final encryptedPassword = _encryptionService.encryptPassword(password);
    await _databaseService.updatePassword(
        id, name, description, encryptedPassword);
  }
}
