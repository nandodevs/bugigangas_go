import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_strings.dart';
import '../../../shared/utils/date_formatter.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../tracking/domain/package_model.dart';
import '../../tracking/presentation/add_package_sheet.dart';
import '../../tracking/presentation/edit_package_sheet.dart';
import '../../tracking/presentation/tracking_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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

  void _showPackageActions(BuildContext context, WidgetRef ref, PackageModel package) {
    final strings = AppStrings.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.description.isNotEmpty
                          ? package.description
                          : package.code,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      package.code,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            letterSpacing: 1.5,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              // Ver Detalhes
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: Text(strings.homeViewDetails),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/tracking/${package.code}');
                },
              ),
              // Editar
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(strings.homeEdit),
                onTap: () {
                  Navigator.of(ctx).pop();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => EditPackageSheet(package: package),
                  );
                },
              ),
              // Arquivar
              ListTile(
                leading: Icon(
                  package.archived ? Icons.unarchive_outlined : Icons.archive_outlined,
                ),
                title: Text(
                  package.archived ? strings.homeUnarchive : strings.homeArchive,
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (package.archived) {
                    ref.read(packageListProvider.notifier)
                        .unarchivePackage(package.code);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.homePackageUnarchived)),
                    );
                  } else {
                    ref.read(packageListProvider.notifier)
                        .archivePackage(package.code);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.homePackageArchived)),
                    );
                  }
                },
              ),
              // Excluir
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  strings.homeDelete,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _confirmDelete(context, ref, package);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, PackageModel package) {
    final strings = AppStrings.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.homeDelete),
        content: Text(strings.homeConfirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(strings.trackingCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(packageListProvider.notifier).removePackage(package.code);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(strings.homePackageDeleted)),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(strings.homeDelete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(filteredPackageListProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPackageSheet(context),
        backgroundColor: const Color(0xFF00A6CD),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header ──────────────────────────────────────
          SliverToBoxAdapter(
            child: _GradientHeader(
              searchQuery: query,
              onSearchChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),

          // ── Quick Filters ────────────────────────────────────────
          SliverToBoxAdapter(
            child: _QuickFilters(
              selectedIndex: ref.watch(statusFilterProvider),
              onFilterChanged: (index) =>
                  ref.read(statusFilterProvider.notifier).state = index,
            ),
          ),
          if (packages.isEmpty)
            SliverToBoxAdapter(
              child: _EmptyPackages(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final package = packages[index];
                  return _PackageCard(
                    package: package,
                    index: index,
                    onTap: () =>
                        _showPackageActions(context, ref, package),
                  );
                },
                childCount: packages.length,
              ),
            ),

          // Bottom padding for the floating nav
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Gradient Header
// ─────────────────────────────────────────────────────────────────────────────

class _GradientHeader extends ConsumerWidget {
  const _GradientHeader({
    required this.searchQuery,
    required this.onSearchChanged,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final userAsync = ref.watch(authStateProvider);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B9B9B), Color(0xFF009696)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row: Avatar + Welcome + Bell ──────────────────────
            Row(
              children: [
                // Avatar with user initial
                userAsync.when(
                  data: (user) => CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: Text(
                      user != null && user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  loading: () => const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  error: (_, __) => const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: userAsync.when(
                    data: (user) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.homeWelcomeBack,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        Text(
                          user?.name ?? '...',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    loading: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.homeWelcomeBack,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 120,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    error: (_, __) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.homeWelcomeBack,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        Text(
                          '...',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Notification bell with badge
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      tooltip: strings.homeNoNotifications,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(strings.homeNoNotifications),
                          ),
                        );
                      },
                    ),
                    // Badge dot
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Title & Subtitle ──────────────────────────────────
            Text(
              strings.homeTrackYourPackage,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.homeAllPackagesOnePlace,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
            ),

            const SizedBox(height: 20),

            // ── Search Bar ────────────────────────────────────────
            TextField(
              controller: TextEditingController.fromValue(
                TextEditingValue(text: searchQuery),
              ),
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: strings.homeTrackingByParcel,
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => onSearchChanged(''),
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Quick Filters
// ─────────────────────────────────────────────────────────────────────────────

class _QuickFilters extends StatelessWidget {
  const _QuickFilters({
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final filters = [
      strings.filterPending,
      strings.filterOutForDelivery,
      strings.filterDelivered,
      strings.filterArchived,
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onFilterChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Package Card
// ─────────────────────────────────────────────────────────────────────────────

/// Circle colors for differentiating packages.
const _circleColors = [
  Color(0xFFFF8A65), // Orange
  Color(0xFF42A5F5), // Blue
  Color(0xFFAB47BC), // Purple
];

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.index,
    required this.onTap,
  });

  final PackageModel package;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final circleColor = _circleColors[index % _circleColors.length];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Leading colored circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Nome + data + status (um abaixo do outro)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Nome da Encomenda
                    Text(
                      package.description,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 2. Data e hora da última atualização
                    if (package.lastUpdate != null)
                      Text(
                        formatDateTime(package.lastUpdate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    const SizedBox(height: 4),
                    // 3. Status atual
                    StatusBadge(
                      status: package.status,
                      compact: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyPackages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Lottie.asset(
            'assets/animations/anim_empty_packages.json',
            width: 100,
            height: 100,
            repeat: true,
            animate: true,
          ),
          const SizedBox(height: 12),
          Text(
            strings.homeNoPackagesYet,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            strings.homeStartTrackingYourFirst,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
