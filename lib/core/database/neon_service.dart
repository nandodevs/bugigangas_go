import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../../features/auth/domain/user_model.dart';
import 'neon_config.dart';

import '../../features/tracking/domain/package_model.dart';

/// Serviço de conexão ao banco PostgreSQL no Neon.
///
/// Fornece métodos CRUD para usuários, sessões, configurações e pacotes.
class NeonService {
  Connection? _conn;

  /// Retorna a conexão ativa, reconectando se necessário.
  Future<Connection> get connection async {
    if (_conn != null && _conn!.isOpen) return _conn!;
    _conn = await Connection.openFromUrl(sanitizedUrl);
    return _conn!;
  }

  /// Remove parâmetros de conexão não reconhecidos pelo driver postgres.
  ///
  /// O Neon pode incluir parâmetros como `channel_binding` que o driver
  /// Dart do postgres não suporta — estes são removidos para evitar erro.
  static String get sanitizedUrl {
    final raw = NeonConfig.databaseUrl;
    final uri = Uri.parse(raw);

    // Parâmetros reconhecidos pelo driver postgres 3.x
    final allowed = <String>{'sslmode', 'application_name', 'connect_timeout', 'query_timeout'};

    final filteredParams = <String, String>{};
    for (final entry in uri.queryParametersAll.entries) {
      if (allowed.contains(entry.key)) {
        filteredParams[entry.key] = entry.value.join(',');
      }
    }

    return Uri(
      scheme: uri.scheme,
      userInfo: uri.userInfo,
      host: uri.host,
      port: uri.port > 0 ? uri.port : null,
      pathSegments: uri.pathSegments,
      queryParameters: filteredParams.isNotEmpty ? filteredParams : null,
    ).toString();
  }

  /// Fecha a conexão atual.
  Future<void> close() async {
    if (_conn != null && _conn!.isOpen) {
      await _conn!.close();
    }
    _conn = null;
  }

  // ── Settings ──────────────────────────────────────────────────────────

  /// Retorna o valor de uma configuração, ou `null` se não existir.
  Future<String?> getSetting(String key) async {
    final conn = await connection;
    final result = await conn.execute(
      Sql.named('SELECT value FROM settings WHERE key = @key'),
      parameters: {'key': key},
    );
    if (result.isEmpty) return null;
    return result.first.first as String?;
  }

  /// Salva um par chave-valor nas configurações.
  Future<void> setSetting(String key, String value) async {
    final conn = await connection;
    await conn.execute(
      Sql.named('''
        INSERT INTO settings (key, value)
        VALUES (@key, @value)
        ON CONFLICT (key) DO UPDATE SET value = @value
      '''),
      parameters: {'key': key, 'value': value},
    );
  }

  // ── Users ─────────────────────────────────────────────────────────────

  /// Retorna o usuário logado com base no `session_token` salvo, ou `null`.
  Future<UserModel?> getCurrentUser() async {
    final token = await getSetting('session_token');
    if (token == null || token.isEmpty) return null;
    return getUserByToken(token);
  }

  /// Busca um usuário pelo email.
  Future<UserModel?> getUserByEmail(String email) async {
    final conn = await connection;
    final result = await conn.execute(
      Sql.named('SELECT * FROM users WHERE email = @email LIMIT 1'),
      parameters: {'email': email},
    );
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first.toColumnMap());
  }

  /// Insere um novo usuário e retorna o ID gerado.
  Future<int> insertUser(UserModel user) async {
    final conn = await connection;
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO users (name, email, password, created_at)
        VALUES (@name, @email, @password, @createdAt)
        RETURNING id
      '''),
      parameters: {
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'createdAt': user.createdAt.toIso8601String(),
      },
    );
    return result.first.first as int;
  }

  /// Remove todos os usuários (logout).
  Future<void> deleteAllUsers() async {
    final conn = await connection;
    await conn.execute(Sql('DELETE FROM users'));
  }

  // ── Sessions ──────────────────────────────────────────────────────────

  /// Cria uma nova sessão para o usuário e retorna o token.
  Future<String> createSession(int userId) async {
    final conn = await connection;
    final token = _generateToken();
    await conn.execute(
      Sql.named('''
        INSERT INTO sessions (user_id, token, created_at)
        VALUES (@userId, @token, @createdAt)
      '''),
      parameters: {
        'userId': userId,
        'token': token,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
    return token;
  }

  /// Busca o usuário logado a partir de um token de sessão.
  Future<UserModel?> getUserByToken(String token) async {
    final conn = await connection;
    final result = await conn.execute(
      Sql.named('''
        SELECT u.* FROM users u
        JOIN sessions s ON s.user_id = u.id
        WHERE s.token = @token
        LIMIT 1
      '''),
      parameters: {'token': token},
    );
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first.toColumnMap());
  }

  /// Remove uma sessão (logout).
  Future<void> deleteSession(String token) async {
    final conn = await connection;
    await conn.execute(
      Sql.named('DELETE FROM sessions WHERE token = @token'),
      parameters: {'token': token},
    );
  }

  /// Gera uma string de token aleatória.
  String _generateToken() {
    final random = DateTime.now().microsecondsSinceEpoch.toString();
    return '${random}_${DateTime.now().millisecondsSinceEpoch}';
  }

  // ── Schema ────────────────────────────────────────────────────────────

  /// Cria as tabelas caso não existam.
  Future<void> ensureSchema() async {
    debugPrint('NeonService.ensureSchema: iniciando…');
    final conn = await connection;

    await conn.execute(Sql('''
      CREATE TABLE IF NOT EXISTS users (
        id         SERIAL PRIMARY KEY,
        name       TEXT NOT NULL,
        email      TEXT NOT NULL UNIQUE,
        password   TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    '''));

    await conn.execute(Sql('''
      CREATE TABLE IF NOT EXISTS sessions (
        id         SERIAL PRIMARY KEY,
        user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        token      TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL
      )
    '''));

    await conn.execute(Sql('''
      CREATE TABLE IF NOT EXISTS packages (
        id          SERIAL PRIMARY KEY,
        user_id     INTEGER REFERENCES users(id) ON DELETE CASCADE,
        code        TEXT NOT NULL,
        description TEXT DEFAULT '',
        tags        TEXT DEFAULT '',
        status      TEXT DEFAULT 'Registrado',
        origin      TEXT DEFAULT '',
        destination TEXT DEFAULT '',
        last_update TEXT,
        created_at  TEXT NOT NULL,
        UNIQUE(user_id, code)
      )
    '''));

    await conn.execute(Sql('''
      CREATE TABLE IF NOT EXISTS settings (
        key   TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    '''));

    // Add columns to existing packages table if not present
    await conn.execute(Sql('''
      ALTER TABLE packages ADD COLUMN IF NOT EXISTS archived BOOLEAN DEFAULT FALSE
    '''));
    await conn.execute(Sql('''
      ALTER TABLE packages ADD COLUMN IF NOT EXISTS tags TEXT DEFAULT ''
    '''));
    await conn.execute(Sql('''
      ALTER TABLE packages ADD COLUMN IF NOT EXISTS carrier TEXT DEFAULT ''
    '''));
    await conn.execute(Sql('''
      ALTER TABLE packages ADD COLUMN IF NOT EXISTS package_type TEXT DEFAULT ''
    '''));
    await conn.execute(Sql('''
      ALTER TABLE packages ADD COLUMN IF NOT EXISTS package_category TEXT DEFAULT ''
    '''));
    await conn.execute(Sql('''
      ALTER TABLE packages ADD COLUMN IF NOT EXISTS estimated_delivery TEXT
    '''));
    await conn.execute(Sql('''
      ALTER TABLE packages ADD COLUMN IF NOT EXISTS delayed BOOLEAN DEFAULT FALSE
    '''));
    await conn.execute(Sql('''
      ALTER TABLE packages ADD COLUMN IF NOT EXISTS locker_delivery BOOLEAN DEFAULT FALSE
    '''));

    // Default settings se não existirem
    await conn.execute(Sql('''
      INSERT INTO settings (key, value)
      SELECT 'language', 'pt'
      WHERE NOT EXISTS (SELECT 1 FROM settings WHERE key = 'language')
    '''));

    await conn.execute(Sql('''
      INSERT INTO settings (key, value)
      SELECT 'onboarding_done', '0'
      WHERE NOT EXISTS (SELECT 1 FROM settings WHERE key = 'onboarding_done')
    '''));

    debugPrint('NeonService.ensureSchema: concluído com sucesso.');
  }

  // ── Packages ───────────────────────────────────────────────────────────

  /// Retorna todos os pacotes de um usuário (pode ser null para anônimo).
  Future<List<PackageModel>> getUserPackages(int? userId) async {
    final conn = await connection;
    final Result result;
    if (userId != null) {
      result = await conn.execute(
        Sql.named(
          'SELECT * FROM packages WHERE user_id = @userId ORDER BY created_at DESC',
        ),
        parameters: {'userId': userId},
      );
    } else {
      result = await conn.execute(
        Sql('SELECT * FROM packages WHERE user_id IS NULL ORDER BY created_at DESC'),
      );
    }
    debugPrint(
      'NeonService.getUserPackages: userId=$userId retornou ${result.length} pacotes',
    );
    return result.map((row) {
      final map = row.toColumnMap();

      // Conversão segura de booleanos — PostgreSQL pode retornar como bool,
      // int (0/1) ou string ('t'/'f') dependendo da versão do driver.
      bool toBool(dynamic v) {
        if (v is bool) return v;
        if (v is int) return v != 0;
        if (v is String) return v == 't' || v == 'true' || v == '1';
        return false;
      }

      return PackageModel(
        code: map['code'] as String,
        status: map['status'] as String? ?? 'Registrado',
        description: map['description'] as String? ?? '',
        tags: (map['tags'] as String? ?? '')
            .split(',')
            .where((t) => t.trim().isNotEmpty)
            .toList(),
        lastUpdate: map['last_update'] != null
            ? DateTime.tryParse(map['last_update'] as String)
            : null,
        origin: map['origin'] as String?,
        destination: map['destination'] as String?,
        events: [],
        archived: toBool(map['archived']),
        carrier: map['carrier'] as String?,
        packageType: map['package_type'] as String?,
        packageCategory: map['package_category'] as String?,
        estimatedDelivery: map['estimated_delivery'] != null
            ? DateTime.tryParse(map['estimated_delivery'] as String)
            : null,
        delayed: toBool(map['delayed']),
        lockerDelivery: toBool(map['locker_delivery']),
      );
    }).toList();
  }

  /// Insere um pacote para um usuário (pode ser null para anônimo).
  Future<void> insertPackage(int? userId, PackageModel package) async {
    debugPrint('NeonService.insertPackage: userId=$userId code=${package.code}');
    final conn = await connection;
    if (userId != null) {
      await conn.execute(
        Sql.named('''
          INSERT INTO packages (user_id, code, description, tags, status, origin, destination, last_update, created_at, carrier, package_type, package_category, estimated_delivery, delayed, locker_delivery)
          VALUES (@userId, @code, @description, @tags, @status, @origin, @destination, @lastUpdate, @createdAt, @carrier, @packageType, @packageCategory, @estimatedDelivery, @delayed, @lockerDelivery)
          ON CONFLICT (user_id, code) DO NOTHING
        '''),
        parameters: {
          'userId': userId,
          'code': package.code,
          'description': package.description,
          'tags': package.tags.join(','),
          'status': package.status,
          'origin': package.origin ?? '',
          'destination': package.destination ?? '',
          'lastUpdate': package.lastUpdate?.toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'carrier': package.carrier ?? '',
          'packageType': package.packageType ?? '',
          'packageCategory': package.packageCategory ?? '',
          'estimatedDelivery':
              package.estimatedDelivery?.toIso8601String(),
          'delayed': package.delayed,
          'lockerDelivery': package.lockerDelivery,
        },
      );
    } else {
      await conn.execute(
        Sql.named('''
          INSERT INTO packages (user_id, code, description, tags, status, origin, destination, last_update, created_at, carrier, package_type, package_category, estimated_delivery, delayed, locker_delivery)
          VALUES (NULL, @code, @description, @tags, @status, @origin, @destination, @lastUpdate, @createdAt, @carrier, @packageType, @packageCategory, @estimatedDelivery, @delayed, @lockerDelivery)
        '''),
        parameters: {
          'code': package.code,
          'description': package.description,
          'tags': package.tags.join(','),
          'status': package.status,
          'origin': package.origin ?? '',
          'destination': package.destination ?? '',
          'lastUpdate': package.lastUpdate?.toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
          'carrier': package.carrier ?? '',
          'packageType': package.packageType ?? '',
          'packageCategory': package.packageCategory ?? '',
          'estimatedDelivery':
              package.estimatedDelivery?.toIso8601String(),
          'delayed': package.delayed,
          'lockerDelivery': package.lockerDelivery,
        },
      );
    }
  }

  /// Atualiza a descrição e tags de um pacote (pode ser null para anônimo).
  Future<void> updatePackage(int? userId, PackageModel package) async {
    final conn = await connection;
    if (userId != null) {
      await conn.execute(
        Sql.named('''
          UPDATE packages
          SET description = @description,
              tags        = @tags,
              status      = @status,
              origin      = @origin,
              destination = @destination,
              last_update = @lastUpdate,
              carrier     = @carrier,
              package_type = @packageType,
              package_category = @packageCategory,
              estimated_delivery = @estimatedDelivery,
              delayed     = @delayed,
              locker_delivery = @lockerDelivery
          WHERE user_id = @userId AND code = @code
        '''),
        parameters: {
          'userId': userId,
          'code': package.code,
          'description': package.description,
          'tags': package.tags.join(','),
          'status': package.status,
          'origin': package.origin ?? '',
          'destination': package.destination ?? '',
          'lastUpdate': package.lastUpdate?.toIso8601String(),
          'carrier': package.carrier ?? '',
          'packageType': package.packageType ?? '',
          'packageCategory': package.packageCategory ?? '',
          'estimatedDelivery':
              package.estimatedDelivery?.toIso8601String(),
          'delayed': package.delayed,
          'lockerDelivery': package.lockerDelivery,
        },
      );
    } else {
      await conn.execute(
        Sql.named('''
          UPDATE packages
          SET description = @description,
              tags        = @tags,
              status      = @status,
              origin      = @origin,
              destination = @destination,
              last_update = @lastUpdate,
              carrier     = @carrier,
              package_type = @packageType,
              package_category = @packageCategory,
              estimated_delivery = @estimatedDelivery,
              delayed     = @delayed,
              locker_delivery = @lockerDelivery
          WHERE user_id IS NULL AND code = @code
        '''),
        parameters: {
          'code': package.code,
          'description': package.description,
          'tags': package.tags.join(','),
          'status': package.status,
          'origin': package.origin ?? '',
          'destination': package.destination ?? '',
          'lastUpdate': package.lastUpdate?.toIso8601String(),
          'carrier': package.carrier ?? '',
          'packageType': package.packageType ?? '',
          'packageCategory': package.packageCategory ?? '',
          'estimatedDelivery':
              package.estimatedDelivery?.toIso8601String(),
          'delayed': package.delayed,
          'lockerDelivery': package.lockerDelivery,
        },
      );
    }
  }

  /// Transfere pacotes anônimos (user_id IS NULL) para um usuário registrado.
  ///
  /// Caso já exista um pacote com o mesmo código para o usuário, o pacote
  /// anônimo é ignorado (não sobrescreve). Os pacotes anônimos migrados
  /// têm seu user_id atualizado; os conflitantes são removidos.
  Future<void> migrateAnonymousPackages(int userId) async {
    final conn = await connection;
    // Atualiza pacotes sem user_id para o novo userId,
    // pulando códigos que já existem para este usuário.
    await conn.execute(
      Sql.named('''
        UPDATE packages
        SET user_id = @userId
        WHERE user_id IS NULL
          AND NOT EXISTS (
            SELECT 1 FROM packages p2
            WHERE p2.user_id = @userId AND p2.code = packages.code
          )
      '''),
      parameters: {'userId': userId},
    );
    // Remove pacotes anônimos que conflitam (mesmo código já existe para o usuário)
    await conn.execute(
      Sql.named('''
        DELETE FROM packages
        WHERE user_id IS NULL
          AND code IN (
            SELECT code FROM packages WHERE user_id = @userId
          )
      '''),
      parameters: {'userId': userId},
    );
  }

  /// Marks a package as archived.
  Future<void> archivePackage(int userId, String code) async {
    final conn = await connection;
    await conn.execute(
      Sql.named(
        'UPDATE packages SET archived = TRUE WHERE user_id = @userId AND code = @code',
      ),
      parameters: {'userId': userId, 'code': code},
    );
  }

  /// Unmarks a package as archived (restores it).
  Future<void> unarchivePackage(int userId, String code) async {
    final conn = await connection;
    await conn.execute(
      Sql.named(
        'UPDATE packages SET archived = FALSE WHERE user_id = @userId AND code = @code',
      ),
      parameters: {'userId': userId, 'code': code},
    );
  }

  /// Remove um pacote de um usuário (pode ser null para anônimo).
  Future<void> deletePackage(int? userId, String code) async {
    final conn = await connection;
    if (userId != null) {
      await conn.execute(
        Sql.named(
          'DELETE FROM packages WHERE user_id = @userId AND code = @code',
        ),
        parameters: {'userId': userId, 'code': code},
      );
    } else {
      await conn.execute(
        Sql.named(
          'DELETE FROM packages WHERE user_id IS NULL AND code = @code',
        ),
        parameters: {'code': code},
      );
    }
  }
}
