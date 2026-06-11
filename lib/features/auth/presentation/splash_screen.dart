import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_providers.dart';

/// Splash screen with intro GIF.
///
/// Exibe o GIF de abertura por 5 segundos e então navega para:
///   - Logado → `/` (home)
///   - Primeira vez → `/welcome`
///   - Retornando sem login → `/login`
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _startTimer() async {
    // Show splash for 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    try {
      final neon = ref.read(neonServiceProvider);
      final onboarding = await neon.getSetting('onboarding_done');
      final language = await neon.getSetting('language');
      final user = await neon.getCurrentUser();

      // Update locale if language was previously saved
      if (language != null) {
        ref.read(localeProvider.notifier).state = Locale(language);
      }

      if (!mounted) return;

      if (user != null) {
        context.go('/');
      } else if (onboarding == null || onboarding == '0') {
        context.go('/welcome');
      } else {
        context.go('/login');
      }
    } catch (e) {
      debugPrint('SplashScreen init error: $e');
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF009696),
        child: Image.asset(
          'assets/intro/intro_app.gif',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
