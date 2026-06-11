import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/language_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/postage/presentation/buy_postage_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/support/presentation/support_screen.dart';
import '../features/tracking/presentation/tracking_screen.dart';
import '../features/tracking/presentation/package_detail_screen.dart';
import '../l10n/app_strings.dart';
import '../shared/widgets/app_shell.dart';
import 'theme/app_icons.dart';

/// GoRouter configuration.
///
/// Route flow:
///   `/splash` (5s timer) → decides:
///     - Logged in → `/` (home)
///     - First time → `/welcome` → `/language` → `/login` → `/` (home)
///     - Returning  → `/login` → `/` (home)
///
/// Routes inside ShellRoute (with FloatingBottomNav):
///   - `/` → [HomeScreen]
///   - `/buy-postage` → [BuyPostageScreen]
///   - `/search` → [SearchScreen]
///   - `/support` → [SupportScreen]
///   - `/profile` → [ProfileScreen]
///
/// Standalone routes (no bottom nav):
///   - `/tracking` → [TrackingScreen]
///   - `/tracking/:code` → [PackageDetailScreen]
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    // ── Error page ──────────────────────────────────────────────────
    errorBuilder: (context, state) => _ErrorPage(
      error: state.error.toString(),
    ),

    routes: [
      // ── Auth flow (no bottom nav) ────────────────────────────────
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/language',
        name: 'language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Shell route with bottom nav ─────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/buy-postage',
            name: 'buyPostage',
            builder: (context, state) => const BuyPostageScreen(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/support',
            name: 'support',
            builder: (context, state) => const SupportScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // ── Standalone routes (outside shell, no bottom nav) ────────
      GoRoute(
        path: '/tracking',
        name: 'tracking',
        builder: (context, state) => const TrackingScreen(),
      ),
      GoRoute(
        path: '/tracking/:code',
        name: 'packageDetail',
        builder: (context, state) {
          final code = state.pathParameters['code']!;
          return PackageDetailScreen(code: code);
        },
      ),
    ],
  );
});

/// Simple error page shown when no route matches.
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(strings.errorTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.errorOutline,
                  size: 64, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(
                strings.errorPageNotFound,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(AppIcons.home),
                label: Text(strings.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
