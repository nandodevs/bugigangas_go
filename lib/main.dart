import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:postgres/postgres.dart';

import 'core/cache/cache_provider.dart';
import 'core/cache/cache_service.dart';
import 'core/database/neon_service.dart';
import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_providers.dart';
import 'l10n/app_strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega variáveis de ambiente do .env
  await dotenv.load(fileName: '.env');

  // Initialize Hive for local caching
  await Hive.initFlutter();
  final cacheService = CacheService();
  await cacheService.init();

  // Garante que as tabelas existem no Neon
  final neon = NeonService();
  try {
    await neon.ensureSchema();

    // Diagnóstico: testa a conexão após ensureSchema
    debugPrint('Testing Neon connection...');
    try {
      final conn = await neon.connection;
      final result = await conn.execute(Sql('SELECT 1'));
      debugPrint('Neon connection test: ${result.first.first}');
    } catch (e) {
      debugPrint('Neon connection test FAILED: $e');
    }
  } catch (e) {
    debugPrint('Erro ao criar schema no Neon: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        neonServiceProvider.overrideWithValue(neon),
        cacheServiceProvider.overrideWithValue(cacheService),
      ],
      child: const _AppInitializer(),
    ),
  );
}

/// Initializes locale and theme from Neon settings before rendering the app.
class _AppInitializer extends ConsumerStatefulWidget {
  const _AppInitializer();

  @override
  ConsumerState<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<_AppInitializer> {
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final neon = ref.read(neonServiceProvider);

    // Load saved language
    try {
      final lang = await neon.getSetting('language');
      if (lang != null && lang.isNotEmpty) {
        ref.read(localeProvider.notifier).state = Locale(lang);
      }
    } catch (e) {
      debugPrint('Error loading language setting: $e');
    }

    // Load saved theme mode
    try {
      final themeMode = await neon.getSetting('theme_mode');
      if (themeMode != null && themeMode.isNotEmpty) {
        switch (themeMode) {
          case 'light':
            ref.read(themeModeProvider.notifier).state = ThemeMode.light;
            break;
          case 'dark':
            ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
            break;
          default:
            ref.read(themeModeProvider.notifier).state = ThemeMode.system;
        }
      }
    } catch (e) {
      debugPrint('Error loading theme mode setting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const BugigangasGoApp();
  }
}

class BugigangasGoApp extends ConsumerWidget {
  const BugigangasGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Bugigangas Go',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        AppStrings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('pt', 'BR');
        for (final supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return const Locale('pt', 'BR');
      },
    );
  }
}
