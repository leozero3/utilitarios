import 'dart:developer';

// import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static const String _key = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

  final encrypt.Key key;
  final encrypt.IV iv;
  final encrypt.Encrypter encrypter;

  // Construtor que inicializa a chave, IV e o encrypter
  EncryptionService()
      : key = encrypt.Key.fromUtf8(_key),
        iv = encrypt.IV.fromLength(16),
        encrypter = encrypt.Encrypter(encrypt.AES(
          encrypt.Key.fromUtf8(_key),
          mode: encrypt.AESMode.cbc, // Modo CBC de operação
        ));

  // Método para criptografar
  String encryptPassword(String password) {
    final encrypted = encrypter.encrypt(password, iv: iv);
    log(encrypted.base64);
    return encrypted.base64; // Retorna a string criptografada em base64
  }

  // Método para descriptografar
  String decryptPassword(String encryptedPassword) {
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: iv);
    log(decrypted); // Imprime a string descriptografada para teste
    return decrypted; // Retorna a string descriptografada
  }
}
