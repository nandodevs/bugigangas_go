import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../l10n/app_strings.dart';
import 'auth_providers.dart';

/// Screen where the user selects their preferred language (pt-BR or en).
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Icon ───────────────────────────────────────────────
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  AppIcons.language,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // ── Title ──────────────────────────────────────────────
              Text(
                strings.languageSelection,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                strings.selectLanguage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // ── Language Options ───────────────────────────────────
              _LangOption(
                emoji: '🇧🇷',
                label: strings.portuguese,
                subtitle: 'Português do Brasil',
                onTap: () => _selectLanguage(ref, context, 'pt'),
              ),
              const SizedBox(height: 12),
              _LangOption(
                emoji: '🇺🇸',
                label: strings.english,
                subtitle: 'American English',
                onTap: () => _selectLanguage(ref, context, 'en'),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectLanguage(
      WidgetRef ref, BuildContext context, String lang) async {
    await ref.read(authActionsProvider).setLanguage(lang);

    // Navigate to login screen, replacing this one.
    context.go('/login');
  }
}

/// A single language option card.
class _LangOption extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _LangOption({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                AppIcons.chevronRight,
                color: AppColors.textHint,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
