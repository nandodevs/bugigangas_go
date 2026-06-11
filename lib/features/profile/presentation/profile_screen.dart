import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_strings.dart';
import '../../auth/presentation/auth_providers.dart';

/// Profile screen accessible from the bottom nav.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.profileTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: userAsync.when(
          data: (user) => _buildProfileContent(context, ref, strings, user),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildProfileContent(context, ref, strings, null),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    AppStrings strings,
    dynamic user,
  ) {
    final userName = user?.name as String? ?? '';
    final userEmail = user?.email as String? ?? '';
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';

    return SingleChildScrollView(
      child: Column(
        children: [
          // Avatar with initials
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName.isNotEmpty ? userName : '...',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            userEmail.isNotEmpty ? userEmail : '...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // ── Settings Section ───────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: Text(
              'Configurações',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          const SizedBox(height: 8),

          // Language selection
          ListTile(
            leading: Icon(Icons.language, color: AppColors.primary),
            title: Text(strings.languageSelection),
            subtitle: Text(
              ref.watch(localeProvider).languageCode == 'pt'
                  ? strings.portuguese
                  : strings.english,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/language'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Theme mode selection
          ListTile(
            leading: Icon(Icons.dark_mode, color: AppColors.primary),
            title: Text(strings.themeMode),
            subtitle: Text(_themeModeLabel(ref.watch(themeModeProvider))),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, ref),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 16),
          // Logout button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => _handleLogout(context, ref),
              icon: const Icon(Icons.logout_rounded),
              label: Text(strings.profileLogout),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Sistema / System';
      case ThemeMode.light:
        return 'Claro / Light';
      case ThemeMode.dark:
        return 'Escuro / Dark';
    }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final current = ref.watch(themeModeProvider);
    final actions = ref.read(authActionsProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  strings.themeMode,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.brightness_auto,
                  color: current == ThemeMode.system ? AppColors.primary : null,
                ),
                title: Text(strings.themeSystem),
                trailing: current == ThemeMode.system
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  actions.setTheme('system');
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.light_mode,
                  color: current == ThemeMode.light ? AppColors.primary : null,
                ),
                title: Text(strings.themeLight),
                trailing: current == ThemeMode.light
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  actions.setTheme('light');
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  color: current == ThemeMode.dark ? AppColors.primary : null,
                ),
                title: Text(strings.themeDark),
                trailing: current == ThemeMode.dark
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  actions.setTheme('dark');
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final strings = AppStrings.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.profileLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(strings.profileLogout),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authActionsProvider).logout();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.profileLogoutSuccess)),
        );
        context.go('/login');
      }
    }
  }
}
