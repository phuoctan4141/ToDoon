// ignore_for_file: prefer_typing_uninitialized_variables, unused_field
// for AES Algorithms

import 'package:encrypt/encrypt.dart';

/// Encrypt data using AES and PKCS7 padding
class EncryptData {
  static Encrypted? _encrypted;
  static var _decrypted;

  static encryptAES(plainText) {
    final key = Key.fromUtf8('Wt99=e}Khh+cJJfGaTsgEe4YB-RZ?g/5');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    _encrypted = encrypter.encrypt(plainText, iv: iv);

    return _encrypted!.base64;
  }

  static decryptAES(plainText) {
    final key = Key.fromUtf8('Wt99=e}Khh+cJJfGaTsgEe4YB-RZ?g/5');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    _decrypted = encrypter.decrypt(Encrypted.from64(plainText), iv: iv);

    return _decrypted;
  }
}
