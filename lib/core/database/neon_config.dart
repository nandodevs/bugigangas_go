import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Carrega as configurações do Neon PostgreSQL a partir do .env
class NeonConfig {
  /// Retorna a URL completa de conexão do Neon.
  ///
  /// Exemplo:
  /// `postgresql://usuario:senha@host.neon.tech/nomedb?sslmode=require`
  static String get databaseUrl {
    final url = dotenv.env['DATABASE_URL'];
    if (url == null || url.isEmpty) {
      throw StateError(
        'DATABASE_URL não encontrada no arquivo .env. '
        'Copie .env.example para .env e preencha com seus dados do Neon.',
      );
    }
    return url;
  }
}
