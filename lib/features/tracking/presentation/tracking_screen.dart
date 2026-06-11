import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_icons.dart';
import '../../../l10n/app_strings.dart';
import '../../../shared/utils/date_formatter.dart';
import '../../../shared/widgets/status_badge.dart';
import '../domain/package_model.dart';
import 'add_package_sheet.dart';
import 'tracking_providers.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(filteredPackageListProvider);
    final query = ref.watch(searchQueryProvider);
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.trackingTitle),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.refresh),
            tooltip: strings.trackingRefresh,
            onPressed: () => ref.read(packageListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: TextEditingController.fromValue(
                TextEditingValue(text: query),
              ),
              decoration: InputDecoration(
                hintText: strings.trackingSearchHint,
                prefixIcon: const Icon(AppIcons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(AppIcons.close),
                        onPressed: () {
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),

          const SizedBox(height: 4),

          // ── Content ──────────────────────────────────────────────
          Expanded(
            child: packages.isEmpty
                ? _EmptyState(query: query)
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.read(packageListProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 80),
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final package = packages[index];
                        return _PackageCard(
                          package: package,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.push('/tracking/${package.code}');
                          },
                          onDelete: () => ref
                              .read(packageListProvider.notifier)
                              .removePackage(package.code),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),

      // ── FAB to add new package ──────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPackageSheet(context),
        icon: const Icon(AppIcons.add),
        label: Text(strings.trackingAdd),
      ),
    );
  }

  /// Shows a bottom sheet where the user can add a package with code, name, and tags.
  void _showAddPackageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddPackageSheet(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Card representing a single tracked package.
class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.onTap,
    required this.onDelete,
  });

  final PackageModel package;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: título + delete ─────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      package.description,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(AppIcons.close, size: 18),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    tooltip: AppStrings.of(context).trackingRemove,
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // ── Data e hora da última atualização ────────────────
                  if (package.lastUpdate != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(AppIcons.clock,
                              size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            formatDateTime(package.lastUpdate),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),

              // ── Status atual ─────────────────────────────────────
              StatusBadge(
                status: package.status,
              ),
            ],
          ),
        ),
      ),
    );
  }

}

/// Empty state widget shown when there are no packages, or search yields nothing.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isSearching = query.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/anim_empty_search.json',
              width: 120,
              height: 120,
              repeat: true,
              animate: true,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? strings.trackingNoResults : strings.trackingNoPackagesYet,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? strings.trackingTryDifferent
                  : strings.trackingAddFirstCode,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
