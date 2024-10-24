import 'dart:convert';

import 'package:crypto/crypto.dart';

class EncryptionService {
  static const String _key = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

  String encryptPassword(String passsword) {
    final key = utf8.encode(_key);
    final bytes = utf8.encode(passsword);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  bool isPasswordIsValid(String password, String encryptedPassword) {
    return encryptPassword(password) == encryptedPassword;
  }
}
