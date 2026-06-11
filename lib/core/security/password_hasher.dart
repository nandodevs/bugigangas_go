import 'dart:convert';
import 'dart:math' as dart_math;

import 'package:crypto/crypto.dart';

/// Serviço para hash de senhas usando SHA-256 com salt.
///
/// Formato armazenado: `salt_base64:hash_hex`
/// - salt: 16 bytes aleatórios
/// - hash: SHA-256(salt + password)
class PasswordHasher {
  /// Gera um salt aleatório de 16 bytes.
  static String _generateSalt() {
    final random = dart_math.Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Retorna o hash no formato `salt:hash`.
  static String hashPassword(String password) {
    final salt = _generateSalt();
    final hash = _sha256(salt, password);
    return '$salt:$hash';
  }

  /// Verifica se a [password] corresponde ao [storedHash] (formato `salt:hash`).
  static bool verifyPassword(String password, String storedHash) {
    final parts = storedHash.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    final hash = parts[1];
    return _sha256(salt, password) == hash;
  }

  static String _sha256(String salt, String password) {
    final bytes = utf8.encode(salt + password);
    return sha256.convert(bytes).toString();
  }
}
