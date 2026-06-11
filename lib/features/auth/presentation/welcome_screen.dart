import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../l10n/app_strings.dart';
import 'auth_providers.dart';

/// Onboarding / welcome screen shown only on the very first app launch.
///
/// Features 3 swipeable pages with indicators. After the last page,
/// the user taps "Get Started" and proceeds to language selection.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    final pages = <_WelcomePage>[
      _WelcomePage(
        icon: AppIcons.inventory2,
        title: strings.welcomePage1Title,
        description: strings.welcomePage1Desc,
      ),
      _WelcomePage(
        icon: AppIcons.language,
        title: strings.welcomePage2Title,
        description: strings.welcomePage2Desc,
      ),
      _WelcomePage(
        icon: AppIcons.chatBubble,
        title: strings.welcomePage3Title,
        description: strings.welcomePage3Desc,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      strings.skip,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // ── PageView ───────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                itemCount: pages.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Icon ──────────────────────────────────
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 56,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // ── Title ─────────────────────────────────
                        Text(
                          page.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // ── Description ───────────────────────────
                        Text(
                          page.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Page Indicators ────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // ── CTA Button ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _currentPage < pages.length - 1
                      ? () {
                          setState(() => _currentPage++);
                        }
                      : _finishOnboarding,
                  child: Text(
                    _currentPage < pages.length - 1
                        ? strings.next
                        : strings.getStarted,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Future<void> _finishOnboarding() async {
    // Mark onboarding as done
    final neon = ref.read(neonServiceProvider);
    await neon.setSetting('onboarding_done', '1');

    if (!mounted) return;
    context.go('/language');
  }
}

/// Data class for each welcome page.
class _WelcomePage {
  final IconData icon;
  final String title;
  final String description;

  const _WelcomePage({
    required this.icon,
    required this.title,
    required this.description,
  });
}
