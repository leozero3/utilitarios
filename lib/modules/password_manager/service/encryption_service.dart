import 'dart:developer';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static const String _key = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

  final encrypt.Key key;
  final encrypt.Encrypter encrypter;

  // Construtor que inicializa a chave e o encrypter
  EncryptionService()
      : key = encrypt.Key.fromUtf8(_key),
        encrypter = encrypt.Encrypter(encrypt.AES(
          encrypt.Key.fromUtf8(_key),
          mode: encrypt.AESMode.cbc, // Modo CBC para garantir a segurança
          padding: 'PKCS7', // Padding PKCS7
        ));

  // Método para criptografar
  String encryptPassword(String password) {
    final iv = encrypt.IV.fromLength(16); // Gerar um IV aleatório

    // Criptografar a senha
    final encrypted = encrypter.encrypt(password, iv: iv);

    // Concatenar IV e a senha criptografada e retornar como base64
    final result =
        iv.base64 + ':' + encrypted.base64; // Usando ':' como delimitador
    log('Encrypted: $result'); // Exibe a string criptografada no log
    return result;
  }

  // Método para descriptografar
  String decryptPassword(String encryptedPassword) {
    try {
      // Dividir a string em IV e parte criptografada usando ':' como delimitador
      final parts = encryptedPassword.split(':');

      // Validar se temos ambas as partes
      if (parts.length != 2) {
        throw FormatException(
            'Formato inválido para descriptografar. String: $encryptedPassword');
      }

      final ivBase64 = parts[0]; // O IV está na primeira parte
      final encryptedBase64 =
          parts[1]; // A senha criptografada está na segunda parte

      // Criar o IV a partir da base64
      final iv = encrypt.IV.fromBase64(ivBase64);

      // Corrigir o comprimento do Base64 para ser múltiplo de 4, se necessário
      String fixedBase64 = _fixBase64(encryptedBase64);

      // Descriptografar a senha
      final decrypted = encrypter.decrypt64(fixedBase64, iv: iv);
      log('Decrypted: $decrypted'); // Exibe a senha descriptografada no log
      return decrypted;
    } catch (e) {
      log('Erro ao descriptografar: $e');
      return 'Erro ao descriptografar';
    }
  }

  // Função para corrigir o Base64 adicionando padding, se necessário
  String _fixBase64(String base64) {
    switch (base64.length % 4) {
      case 1:
        throw FormatException('Base64 inválido');
      case 2:
        return base64 + '==';
      case 3:
        return base64 + '=';
      default:
        return base64;
    }
  }
}
