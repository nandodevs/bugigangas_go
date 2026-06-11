import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/neon_service.dart';
import '../../../core/security/password_hasher.dart';
import '../domain/user_model.dart';

/// Provider singleton do NeonService.
final neonServiceProvider = Provider<NeonService>((ref) => NeonService());

/// Current app locale. Defaults to `pt`. Updated when user selects language
/// or on app start when a saved language is found.
final localeProvider = StateProvider<Locale>((ref) => const Locale('pt', 'BR'));

/// Current theme mode. Defaults to [ThemeMode.system].
/// Persisted in Neon settings table as 'theme_mode'.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Provider that checks if a user is logged in.
///
/// Returns `null` while loading, or the [UserModel] if found.
final authStateProvider = FutureProvider<UserModel?>((ref) async {
  final neon = ref.watch(neonServiceProvider);
  return neon.getCurrentUser();
});

/// Actions related to authentication and settings.
///
/// Inject this provider and call methods like `register(...)`, `login(...)`.
final authActionsProvider = Provider<AuthActions>((ref) => AuthActions(ref));

class AuthActions {
  final Ref _ref;
  AuthActions(this._ref);

  /// Saves the language preference and updates the app locale.
  Future<void> setLanguage(String lang) async {
    final neon = _ref.read(neonServiceProvider);
    await neon.setSetting('language', lang);
    _ref.read(localeProvider.notifier).state = Locale(lang);
  }

  /// Saves the theme mode preference and updates the app theme.
  Future<void> setTheme(String themeMode) async {
    final neon = _ref.read(neonServiceProvider);
    await neon.setSetting('theme_mode', themeMode);
    _ref.read(themeModeProvider.notifier).state = _parseThemeMode(themeMode);
  }

  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Registers a new user and creates a session (auto-login).
  Future<UserModel> register(String name, String email, String password) async {
    final neon = _ref.read(neonServiceProvider);
    final user = UserModel(
      name: name,
      email: email,
      password: PasswordHasher.hashPassword(password),
      createdAt: DateTime.now(),
    );
    await neon.insertUser(user);

    // Migrate anonymous packages if any, then create session
    await _migrateAnonymousPackages(neon, user.id!);
    final token = await neon.createSession(user.id!);
    await neon.setSetting('session_token', token);

    return user;
  }

  /// Logs in with email and password. Returns `null` if credentials are invalid.
  Future<UserModel?> login(String email, String password) async {
    final neon = _ref.read(neonServiceProvider);
    final user = await neon.getUserByEmail(email);
    if (user == null || !PasswordHasher.verifyPassword(password, user.password)) return null;

    // Migrate anonymous packages if any, then create session
    await _migrateAnonymousPackages(neon, user.id!);
    final token = await neon.createSession(user.id!);
    await neon.setSetting('session_token', token);

    return user;
  }

  /// Logs out by deleting the session. The user account is kept in the database.
  Future<void> logout() async {
    final neon = _ref.read(neonServiceProvider);
    final token = await neon.getSetting('session_token');
    if (token != null) {
      await neon.deleteSession(token);
    }
    await neon.setSetting('session_token', '');
    _ref.invalidate(authStateProvider);
  }

  /// Migrates anonymous packages (stored in `packages` with user_id IS NULL)
  /// to the now-logged-in user.
  Future<void> _migrateAnonymousPackages(NeonService neon, int userId) async {
    try {
      await neon.migrateAnonymousPackages(userId);
    } catch (e) {
      debugPrint('Erro ao migrar pacotes anônimos: $e');
    }
  }
}
